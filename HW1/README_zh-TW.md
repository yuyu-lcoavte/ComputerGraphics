# Computer Graphics Lab 1

## 一、作業內容

這次作業主要是利用 Processing 提供的程式架構，自己實作畫線、畫圓、畫橢圓、Bézier 曲線以及橡皮擦的功能，另外也新增 Spray 噴漆功能作為 BONUS。

### 已完成功能

- CGLine：直線（也會用在 Polygon 和 Pencil）
- CGCircle：圓形
- CGEllipse：橢圓形
- CGCurve：Bézier 曲線
- CGEraser：橡皮擦

## 二、實作方式

### 1. CGLine — Midpoint Line Algorithm

先用 `dx`、`dy` 判斷直線主要往 x 還是 y 方向移動，再根據判斷值 `d` 決定下一步要畫哪個點。使用 `sx`、`sy` 處理不同方向的直線，就不用分成八種情況寫。

因為使用 `!=` 判斷是否到終點，所以先把座標用 `round()` 轉成整數，避免無法結束迴圈。

### 2. CGCircle — Midpoint Circle Algorithm

從 `(0, R)` 開始，根據 `d` 決定下一步選 E 還是 SE，再利用圓的八向對稱畫出其他點，這樣就不用整個圓都重新計算。

### 3. CGEllipse — Midpoint Ellipse Algorithm

橢圓分成兩個區域處理。Region 1 主要往 x 方向移動，依照 `d1` 選 E 或 SE；Region 2 主要往 y 方向移動，依照 `d2` 選 S 或 SE。每次都利用四向對稱畫出其他點。

### 4. CGCurve — Cubic Bézier Curve

利用四個控制點及 Bézier Curve 公式計算曲線上的位置，讓 `t` 從 0 變化到 1，再將算出的點畫出來。取樣次數會參考控制點之間的總距離，讓曲線比較不容易出現空隙。

### 5. CGEraser — 橡皮擦

先找出兩個點所形成的矩形範圍，再用兩層 `for` 迴圈把範圍內的點畫成背景色 `color(250)`，就能達到擦除的效果。

## 三、BONUS — Spray

這次 BONUS 選擇新增噴漆功能，讓使用者可以透過滑鼠在畫布上噴出隨機分布的小點。

主要是使用 random() 在滑鼠附近產生隨機座標，再利用圓的公式 dx² + dy² <= r² 判斷這些點有沒有在噴漆範圍內，最後使用 drawPoint() 把符合條件的點畫出來。

另外參考原本 Pencil 的架構，新增 SprayRenderer 處理滑鼠操作，並利用 Spray 類別儲存噴漆的座標，讓放開滑鼠後仍然可以保留畫出的結果，也能使用原本的 Undo 和 Clear 功能。

## 四、實作過程與 AI 使用說明

這次我是先跟著課堂講義和參考資料理解演算法，再自己實作一次。遇到不太懂的公式或判斷方式時，會再查資料或詢問 ChatGPT，也有請它用簡單的座標例子模擬每一步怎麼選點、判斷值怎麼改變，讓我更清楚 Midpoint 和 Bézier Curve 的作圖原理。

初步完成後，我把程式提供給 ChatGPT，請它幫忙檢查有沒有遺漏或寫錯的地方，也請它協助補上簡短的程式註解，以及整理這份 README。例如直線原本使用 `while (x != endX)`，討論後發現非整數座標可能無法剛好走到終點，所以後來加上 `round()`。

BONUS 的部分則是先和 ChatGPT 討論哪個功能比較容易實作，最後選擇 Spray 噴漆功能。因為這部分需要配合原本的程式架構，所以有詢問 ChatGPT 應該在哪裡新增按鈕、如何實作，也有參考 AI 提供的程式碼，並進一步了解各部分的用途與實作原理。

整體還是以自己參考講義後實作的版本為主，再透過 AI 協助理解、檢查與調整，BONUS 的部分依靠 AI 比較多。

## 五、執行結果

### 1. 直線（Line）

<img width="800" height="663" alt="image" src="https://github.com/user-attachments/assets/168d19c3-fabe-4596-abc7-752cc768b385" />

### 2. 圓形（Circle）

<img width="798" height="664" alt="image" src="https://github.com/user-attachments/assets/418f0a68-7e9b-4325-aecf-b9f9e792033d" />

### 3. 橢圓形（Ellipse）

<img width="798" height="663" alt="image" src="https://github.com/user-attachments/assets/811dd00e-e7cc-4523-abf9-d9003ef2dcc2" />

### 4. Bézier 曲線（Curve）

<img width="797" height="661" alt="image" src="https://github.com/user-attachments/assets/9f80262e-a6a7-4eb9-b4e9-a8ac0c053893" />

### 5. 橡皮擦（Eraser）

<img width="796" height="662" alt="image" src="https://github.com/user-attachments/assets/a2d0f06b-8005-4df5-bdf8-449faba34a2f" />

### 6. BONUS — Spray

<img width="798" height="662" alt="image" src="https://github.com/user-attachments/assets/3f24486b-3cfd-45d8-b745-86effca695e5" />

## 六、參考資料

- 課堂講義：Midpoint Line、Midpoint Circle、Midpoint Ellipse、Bézier Curve
- [CG Lab 1 作業說明的橢圓參考連結] https://www.geeksforgeeks.org/midpoint-ellipse-drawing-algorithm/
- [CG Lab 1 作業說明的曲線參考連結] https://javascript.info/bezier-curve
