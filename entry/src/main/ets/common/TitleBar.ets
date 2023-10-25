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
import { importText } from '../model/New'

@Component
export struct TitleBar {
  private title: Resource = $r("app.string.entry_title");
  @State text: string = ''
  string = importText()
  build() {
    Column(){
      Row() {
        Button("导入")
          .onClick((event: ClickEvent) => {Text(this.string)})
          .backgroundColor("#F5F5F5")
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .fontSize(30)
          .margin({left: 5})
      }
      .width('100%')
      .padding({ left: 10 })
    }
  }
}