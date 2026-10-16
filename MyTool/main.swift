import Foundation

// https://github.com/ralfslima/ios_capgemini/blob/main/Aula%2009/README.md

protocol Documento {
    var id: UUID {get}
    
    func exibirDetalhes() -> String;
}

class Livro: Documento {
    var id: UUID
    private var _titulo: String
    private var _autor: String
    private var _anoPublicacao: String
    private var _isEmprestado: Bool
    
    init(id: UUID, _titulo: String, _autor: String, _anoPublicacao: String, _isEmprestado: Bool) {
        self.id = UUID()
        self._titulo = _titulo
        self._autor = _autor
        self._anoPublicacao = _anoPublicacao
        self._isEmprestado = _isEmprestado
    }
    
    func exibirDetalhes() -> String {
        return "Identificador: \(id) | Titulo: \(_titulo) | Autor: \(_autor) | Ano publicado: \(_anoPublicacao)"
    }
    
    func emprestar() -> Void {
        self._isEmprestado = true
    }
    
    func devolver() -> Void {
        self._isEmprestado = false
    }
    
    var titulo: String {
        get {return _titulo}
        set(titulo) { _titulo = titulo }
    }
    
    var autor: String {
        get { return _autor }
        set(autor) { _autor = autor}
    }
}

struct LivroStruct: Documento {
    var id: UUID
    private var _titulo: String
    private var _autor: String
    private var _anoPublicacao: Int
    private var _isEmprestado: Bool
    
    func exibirDetalhes() -> String {
        return "Identificador: \(id) | Titulo: \(_titulo) | Autor: \(_autor) | Ano publicado: \(_anoPublicacao)"
    }
    
//    func emprestar() -> Void {
//        _isEmprestado = true
//    }
//
//    func devolver() -> Void {
//        _isEmprestado = false
//    }
}

enum OpcoesEditarEnum: String {
    case titulo = "1"
    case autor = "2"
    case devolver = "3"
    case fazerEmprestimo = "4"
}

enum ErrorLivros: Error {
    case LivroNaoEncontrado(id: UUID)
    case OpcaoNaoEncontrada(valor: String)
    case OpcaoEmprestadaIncorreta(valor: String)
}

class GerenciarLivros {
    private var _vetor: [Livro] = []
    
    func cadastrar(obj: Livro) -> Void {
        _vetor.append(obj)
    }
    
    func listar() -> Void {
        if _vetor.isEmpty {
            print("NENHUM LIVRO CADASTRADO")
            
            return
        } else {
            for item in _vetor {
                print(item.exibirDetalhes())
                print("--------------------")
            }
        }
        
    }
    
    func buscar(id: UUID) throws -> Livro {
        let livrosFiltrados = _vetor.filter { $0.id == id}
        
        for livro in livrosFiltrados {
            return livro;
        }
        
        throw ErrorLivros.LivroNaoEncontrado(id: id)
        
    }
    
    func excluir(id: UUID) -> Void {
        _vetor.removeAll(where: { $0.id == id  })
    }
    
    func editar(livro: Livro, opcaoEditarSelecionada: String, valor: String) -> Void {
        switch OpcoesEditarEnum(rawValue: opcaoEditarSelecionada) {
            case .titulo?:
                livro.titulo = valor
                
            case .autor?:
                livro.autor = valor
                
            case .devolver?:
                livro.devolver()
                
            case .fazerEmprestimo?:
                livro.emprestar()
            
        case nil:
            print("Opção invalida")
        }
    }
}

print("----- BEM VINDO AO SISTEMA DE GERENCIAMENTO DA BIBLIOTECA -----")
print("Digite ENTER para iniciar ou digite qualquer valor para encerrar")
var iniciarOuFinalizar = readLine()
var vetorLivros = GerenciarLivros()

while iniciarOuFinalizar == "" {
    print("1 - Cadastrar um livro\n2 - Buscar o livro por ID \n3 - Listar todos os livros\n4 - Editar\n5 - Remover\n0 - Sair ")
    let acao = readLine()
    
    switch acao {
    case "1":
        print("Titulo do livro:")
        let titulo = readLine()
        
        print("Autor:")
        let autor = readLine()
        
        print("Ano de publicacao:")
        let ano = readLine()
        
        let livro = Livro(id: UUID(), _titulo: titulo ?? "", _autor: autor ?? "", _anoPublicacao: ano ?? "", _isEmprestado: false)
        print(livro.exibirDetalhes())
        vetorLivros.cadastrar(obj: livro)
        print("Sucesso")
        
    case "2":
        print("Digite o ID")
        let idInput = readLine()
        
        if let id = idInput, let uuidConvertido = UUID(uuidString: id) {
            do {
                let livro = try vetorLivros.buscar(id: uuidConvertido)
                
                print(livro.exibirDetalhes())
            } catch ErrorLivros.LivroNaoEncontrado(id: uuidConvertido) {
                print("Livro não encontrado")
                break
            }
        } else {
            print("ID inválido ou formato incorreto.")
            break
        }
    case "3":
        print(vetorLivros.listar())
        
    case "4":
        print("Digite o ID do livro:")
        let idInput = readLine()
        
        var livro: Livro
        if let id = idInput, let uuidConvertido = UUID(uuidString: id) {
            do {
                livro = try vetorLivros.buscar(id: uuidConvertido)
            } catch ErrorLivros.LivroNaoEncontrado(id: uuidConvertido) {
                print("Livro não encontrado")
                break
            }
        } else {
            print("ID inválido ou formato incorreto.")
            break
        }
        
        var opcaoEditarDesejado: String = ""
        var encerrarEdicao = false
        while encerrarEdicao != true {
            print("O que você deseja editar? \n1. Titulo \n2. Autor\n3. Fazer empréstimo de livro \n4. Devolver livro")
            let optDigitado = readLine() ?? ""
            
            if let opcaoValida = OpcoesEditarEnum(rawValue: optDigitado) {
                opcaoEditarDesejado = optDigitado
                break
            } else {
                print("Opção incorreta, deseja tentar novamente? (Y/n)")
                let opcao = readLine() ?? "Y"
                
                if(opcao == "n") {
                    encerrarEdicao = true
                }

                continue
            }
            
            opcaoEditarDesejado = optDigitado
        }
        
        var valor = ""
        if opcaoEditarDesejado != OpcoesEditarEnum.fazerEmprestimo.rawValue || opcaoEditarDesejado != OpcoesEditarEnum.devolver.rawValue {
            print("Digite o valor que deseja ser atualizado:")
            valor = readLine() ?? ""
        } else {
            valor = ""
        }
        
        vetorLivros.editar(livro: livro, opcaoEditarSelecionada: opcaoEditarDesejado, valor: valor)
        print("Valor atualizado")
        vetorLivros.listar()

        case "0":
            print("SAINDO...")
            exit(0)
            
    case "5":
        print("Digite o ID do livro:")
        let idInput = readLine()
        
        if let id = idInput, let uuidConvertido = UUID(uuidString: id) {
            do {
                _ = try vetorLivros.buscar(id: uuidConvertido)
                
                vetorLivros.excluir(id: uuidConvertido)
                print("Removido o livro do id: \(uuidConvertido)")
            } catch ErrorLivros.LivroNaoEncontrado(id: uuidConvertido) {
                print("Livro não encontrado")
                break
            }
        } else {
            print("ID inválido ou formato incorreto.")
            break
        }
        
            
    default:
        print("Opção incorreta")
    }
    
    print("DESEJA CONTINUAR? Se sim, tecle enter. Se nao, digite qualquer valor")
    iniciarOuFinalizar = readLine()
}


