# Swift_TodoList
## iOS 숙련자 개인 과제
### 필수 과제
- **'UserDefaults'** 를 사용해서 데이터 일관성 유지하기
- **'Life Cycle'** 고려하여 데이터를 불러오는 시점을 설계하기
    - WriteTodoViewController에서 '할일'을 작성 후 수정을 통해 카테고리 및 내용을 수정하고 나면 todoTableView를 다시 한 번 그려줘야 하기 때문에 viewWillAppear() 함수를 통해 reloadData()로 재로드 해줌.
- TableView의 Section과 Header/Footer를 사용해 Todo데이터 나타내기
    - Section을 나누는 것에서 막혀 시간이 많이 걸렸다. 새로 파일을 만든 후 Section에 대해 공부를 한 후에 코드를 수정하니 다행히 해결했다. 문제가 있었던 부분은 각 셀들의 정보를 반환 및 상태를 업데이트 해주는 tableView() 메서드에서 "index out of range" 오류가 발생하여 indexPath.row < 카테고리.카운트 제한을 둬 해결하였다. Footer 부분에는 딱히 무엇을 넣을 생각이 없었기 때문에 줄바꿈을 넣여줘 섹션끼리의 공간을 넓혀줌
- 홈화면에 이미지 URL을 활용하여 UIImageView에 표시하기
---
### 선택구현
- 'UserDefaults'를 사용해 Todo 데이터 삭제 및 수정.
    - 저번 과제에서 삭제랑 수정 기능을 넣었지만 이번 과제에서 삭제 기능을 '할일목록' 뷰에서도 넣어줘 필요하지 않느 셀을 삭제. 기존 수정은 Alert 형식이였지만 카테고리 추가를 위해서 EditVC를 통해 수정을 해줌.
- App Icon, Launch Screen 설정
    - 런치 스크린에서는 키우고 있는 강아지 사진을 삽입
    - 아이콘은 Todo와 맞는 이미지를 선택
- 랜덤 고양이 사진 페이지 만들기
    - 고양이 모양의 이모티콘 버튼을 만든 후 눌렀을 떄 CatVC로 이동
    - API 이미지를 받아 UIImageView에 넣어줌
- 새로고침 버튼을 생성해 눌렀을 때마다 새로운 이미지 삽입
- placeholderImage를 설정해줌으로 써 시간이 오래걸리거나 사용자가 당황할 떄를 대비
---

### 개인과제 설명
- Model
    - 'Task', 'Category', 'DataManager' 클래스가 모델에 해당함. 데이터를 정의 및 관리하며 앱의 상태와 로직을 관리한다. 
    - 'Task' 할 일 항목을 나타내는 데이터 구조체
    - 'Category' 할 일 항목의 카테고리 열거형
    - 'DataManager' 할 일 항목들을 관리 및 조직하는 메서드 제공
- View
    - 'VC', 'WriteTodoVC', 'EditVC', 'CompletedVC', 'CatImageVC' 클래스가 뷰에 해당함.
    - 'VC' 즉, 메인 뷰이며, 다른 뷰로 갈 수 있는 버튼 및 url로 이미지를 보여줌.
    - 'WriteTodoVC' 할 일을 작성 및 관리 화면을 보여줌
    - 'CompletedVC'은 'WriteVC'에서 완료한 할 일들 목록을 보여줌
    - 'CatImageVC' 랜덤 고양이 사진을 보여줌
- Controller
    - 'WriteVC', 'EditVc', 'CompletedVC', 'CatImageVC' 클래스가 컨트롤러에 해당함. 사용자의 입력을 처리하며 모델의 상태를 업데이트 및 뷰의 표시.
    - 'WriteVC' 할 일들을 추가 및 삭제 작업을 처리.
    - 'EditVC'은 'WriteVC'에서 추가한 할 일의 내용 및 카테고리 수정 작업.
    - 'CompletedVC' 완료한 할 일들을 삭제 작업
    - 'CatImageVC' 고양이 이미지를 랜덤으로 받아와 뷰에 표시하는 작업