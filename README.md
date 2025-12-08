
# Tattoo AR Studio

**Tattoo AR Studio** é um aplicativo móvel que permite aos usuários **visualizar tatuagens em tempo real usando realidade aumentada (AR)**, explorar estilos de tatuagem, selecionar regiões do corpo e agendar serviços em estúdios parceiros. Também inclui uma **loja de piercings** e uma galeria de trabalhos inspiradores.

---

## 📱 Funcionalidades Principais

* **Simulação AR de tatuagens**

  * Posicione, redimensione e rotacione tatuagens virtualmente no corpo usando a câmera do dispositivo.
  * Captura de screenshots para compartilhar ou salvar localmente.

* **Exploração de estilos de tatuagem**

  * Navegue por diferentes estilos: Realismo, Fineline, Old School, Neotradicional, Blackwork, Aquarela, Tribal e Minimal.

* **Seleção de regiões do corpo**

  * Escolha áreas do corpo para simular a tatuagem: braço, perna, costas, peito, rosto, entre outras.

* **Agendamento de serviços**

  * Escolha data e horário para reservar sessões no estúdio.
  * Interface simples e intuitiva via `BottomSheet`.

* **Galeria de trabalhos**

  * Inspiração com imagens de tatuagens reais.
  * Visualização detalhada e opção de agendar a tatuagem diretamente a partir da galeria.

* **Loja de piercings**

  * Exibição de produtos, preços e imagens.
  * Adicionar produtos ao carrinho com feedback visual.

---

## 🛠 Tecnologias Utilizadas

* **Flutter & Dart**: framework multiplataforma para Android e iOS.
* **AR Simulation**: implementação própria para overlay de tatuagens com gestos (zoom, arrastar e girar).
* **Camera / Screenshot**: integração com câmera para preview em AR e captura de imagens.
* **Widgets personalizados**: ListViews horizontais, GridViews e PageViews para galerias e seletores.
* **Gerenciamento de estado**: `setState` para pequenas interações; pronto para integrar soluções mais avançadas.

---

## 🎨 Estrutura do App

* **HomePage**: Tela principal com cabeçalho, carousel de trabalhos, seletores de estilos e regiões, loja de piercings e galeria completa.
* **ARSimulatorScreen**: Tela de simulação AR para testar tatuagens virtualmente.
* **BottomSheet de agendamento**: Permite ao usuário escolher data e hora da sessão.

---

## 🚀 Instalação e Execução

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/tattoo-ar-studio.git
```

2. Navegue até o diretório do projeto:

```bash
cd tattoo-ar-studio
```

3. Instale dependências:

```bash
flutter pub get
```

4. Execute o app:

```bash
flutter run
```

> Compatível com dispositivos Android e iOS. Para AR completo, a câmera precisa estar disponível.

---

## 📂 Estrutura de Pastas

```
lib/
├── main.dart                 # Entry point do app
├── routes/
│   └── app_routes.dart       # Rotas centralizadas
├── presentation/
│   └── screens/
│       ├── home_page.dart
│       └── ar_simulator_screen.dart
├── widgets/                  # Widgets reutilizáveis
└── models/                   # Modelos de dados (tatuagens, piercings)
```

---

## 🤝 Contribuição

Contribuições são bem-vindas!

* Faça um fork do projeto
* Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
* Faça commit das suas alterações (`git commit -m 'Adiciona nova funcionalidade'`)
* Envie para o repositório (`git push origin feature/nova-funcionalidade`)
* Abra um Pull Request

---

## 📄 Licença

MIT License – consulte o arquivo LICENSE para mais detalhes.

---

Created by Maurício H.N.Silva Destiny7 Softwares 2025.
