/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import fs from '@ohos.file.fs'
import picker from '@ohos.file.picker';
import mediaQuery from '@ohos.mediaquery'
import Logger from '../model/Logger'
import util from '@ohos.util'

const TAG = 'MainIndex'

@Entry
@Component
struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State uri: string = 'Hello World'
  @State res: string = ''
  @State fontSize: number = 15
  @State isLand: boolean = false
  @State prog: string = ''
  private scroller: Scroller = new Scroller()

  onLand(mediaQueryResult) {
    Logger.info(`${TAG} onLand: mediaQueryResult.matches=${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  aboutToAppear() {
    this.listener.on('change', this.onLand.bind(this))
  }

  async importText() {
    let textSelector = new picker.DocumentSelectOptions();
    let documentViewPicker = new picker.DocumentViewPicker(); // 创建文件选择器实例
    documentViewPicker.select(textSelector).then((DocumentSelectResult) => {
      DocumentSelectResult.forEach((value) => {
        this.uri = value;
      })
    })
    let file = fs.openSync(this.uri);
    let buf = new ArrayBuffer(64 * 1024 * 1024);
    let rd = new util.TextDecoder("utf-8", {ignoreBOM: true})
    fs.read(file.fd, buf, (err, readLen) => {
      this.res = rd.decode(new Uint8Array(buf.slice(0, readLen)));
      fs.closeSync(file);
    })
  }

  /*Progress() {
  let pageHeight = document.body.scrollHeight || document.documentElement.scrollHeight;
  let windowHeight = document.documentElement.clientHeight || document.body.clientHeight;
  let scrollAvail = pageHeight - windowHeight;
  window.onscroll = function () {
      let scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
      document.querySelector('.scrollBar').style.width = (scrollTop/scrollAvail)*100   '%';
  };
}*/


  build() {
    Row() {
      Column() {
        Row() {
          Text("txt阅读器")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .margin({ left: 15, right: 15 })
            .layoutWeight(2)
          Select([{ value: '10vp'}, { value: '15vp'}, { value: '20vp'}, { value: '25vp'}, {value: '30vp'}, { value: '35vp'}])
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .selected(1)
            .value('字号')
            .font({ size: 25, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 25, weight: 400 })
            .optionFont({ size: 20, weight: 400 })
            .onSelect((index: number) => {
              this.fontSize = 5 * (index + 2)
            })
            .margin({ left: 15, right: 15 })
            .layoutWeight(1)
          Button("导入")
            .onClick((event: ClickEvent) => {this.importText()})
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .margin({ left: 15, right: 15 })
            .layoutWeight(1)

        }
        .height("8%")
        Row()
        {
          Scroll(this.scroller) {
            Text(this.res)
              .fontSize(this.fontSize)
              .width('100%')
              .onClick(() => {(this.prog = (this.scroller.currentOffset().yOffset / 16707.8 * 100).toFixed(0))})
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Auto)
          .scrollBarColor(Color.Gray)
          .scrollBarWidth(10)
        }
        .height("84%")
        Row()
        {
          Text(this.prog.toString() + "%")
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .onClick(() => {(this.prog = (this.scroller.currentOffset().yOffset / 16707.8 * 100).toFixed(0))})
          Button("回到开头")
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .onClick(() => { this.scroller.scrollTo({xOffset :0,yOffset: 0})})
          Button("去到结尾")
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .onClick(() => { this.scroller.scrollBy(0,99999999999)})
          Button("前进10%")
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .onClick(() => { this.scroller.scrollBy(0,1733)})
          Button("后退10%")
            .backgroundColor("ffffff")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(20)
            .onClick(() => { this.scroller.scrollBy(0,-1733)})
        }
        .height("8%")
      }
      .size({ width: '100%', height: '100%' })
    }
  }
}