import router from '@ohos.router'

@Entry
@Component
struct FirstPage {
  build() {
    Column() {
      Text("第一个页面")
        .fontSize(20)

      Button("跳转")
        .width("50%")
        .height(50)
        .onClick(() => {
          router.pushUrl({ url: "pages/routes/SecondPage", params: {
            param: "第一个页面传来的值",
          } })
        })
        .margin(10)
    }
    .width("100%")
    .height("100%")
  }
}