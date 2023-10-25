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
import router from '@ohos.router'
import picker from '@ohos.file.picker';
import mediaQuery from '@ohos.mediaquery'
import Logger from '../model/Logger'
import { newsList } from '../model/New'
import { NewView } from '../common/NewView'
import { TextType } from '../model/DataModel'


const TAG = 'MainIndex'

@Entry
@Component
struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State currentNew: TextType = null
  @State uri: string = 'Hello World'
  @State isLand: boolean = false

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

  async importText()
  {
    let textSelector = new picker.DocumentSelectOptions();
    let documentViewPicker = new picker.DocumentViewPicker(); // 创建文件选择器实例
    documentViewPicker.select(textSelector).then((DocumentSelectResult) => {DocumentSelectResult.forEach((value) => {this.uri = value;})})
  }

  build() {
    Row() {
      Column() {
        Row(){
          Text("txt阅读器")
            .backgroundColor("#F5F5F5")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(25)
            .padding({left: 15})
            .layoutWeight(6)
          Button("导入")
            .onClick((event: ClickEvent) => {this.importText()})
            .backgroundColor("#F5F5F5")
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Normal)
            .fontSize(25)
            .padding({right: 15})
            .layoutWeight(1)
        }
        List() {
          ForEach(newsList, (item, index) => {
            ListItem() {
              Column() {
                Text(item.title)
                  .id(`item${index}`)
                  .width('100%')
                  .fontSize(20)
                Text(item.publisher)
                  .width('100%')
                  .fontSize(16)
                  .fontColor(Color.Gray)
              }
              .padding(10)
              .height('10%')
              .constraintSize({ minHeight: 80 })
              .backgroundColor(Color.White)
              .justifyContent(FlexAlign.Center)
            }
            .onClick(() => {
              if (!this.isLand) {
                router.push({
                  params: { title: item.title, newId: item.newId },
                  url: 'pages/New' })
              } else {
                this.currentNew = null
              }
            })
          }, item => JSON.stringify(item))
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, startMargin: 15, endMargin: 15 })
        .padding({ left: 10, right: 10 })
      }
      .layoutWeight(2)
      .height('100%')
      .backgroundColor($r('app.color.indexPage_color'))


      if (this.isLand) {
        NewView({ currentText: $currentNew })
      }
    }
    .size({ width: '100%', height: '100%' })
  }
}