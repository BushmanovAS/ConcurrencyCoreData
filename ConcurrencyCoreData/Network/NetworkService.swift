//
//  File.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 08.09.2025.
//

import Foundation

protocol INetworkService {
    func getData1() async throws -> [Country]
    func getData2() async throws -> [Country]
}

final class NetworkService: INetworkService {
    
    func getData1() async throws -> [Country] {
        [
            Country(
                id: UUID(),
                name: "Германия",
                population: 83000000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Берлин",
                        population: 3769000,
                        streets: [
                            Street(id: UUID(), name: "Унтер-ден-Линден", population: 1500),
                            Street(id: UUID(), name: "Курфюрстендамм", population: 2200),
                            Street(id: UUID(), name: "Фридрихштрассе", population: 1800)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Мюнхен",
                        population: 1488000,
                        streets: [
                            Street(id: UUID(), name: "Нойхаузер-штрассе", population: 1200),
                            Street(id: UUID(), name: "Кауфингерштрассе", population: 900),
                            Street(id: UUID(), name: "Максимилианштрассе", population: 800)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Гамбург",
                        population: 1841000,
                        streets: [
                            Street(id: UUID(), name: "Юнгфернштиг", population: 1100),
                            Street(id: UUID(), name: "Мёнкебергштрассе", population: 1300),
                            Street(id: UUID(), name: "Репербан", population: 950)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Франция",
                population: 67390000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Париж",
                        population: 2148000,
                        streets: [
                            Street(id: UUID(), name: "Елисейские поля", population: 2500),
                            Street(id: UUID(), name: "Рю де Риволи", population: 1900),
                            Street(id: UUID(), name: "Бульвар Сен-Мишель", population: 1600)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Марсель",
                        population: 861000,
                        streets: [
                            Street(id: UUID(), name: "Ля Канбьер", population: 1400),
                            Street(id: UUID(), name: "Рю де ла Репюблик", population: 1100),
                            Street(id: UUID(), name: "Рю Сен-Ферреоль", population: 950)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Лион",
                        population: 516000,
                        streets: [
                            Street(id: UUID(), name: "Рю де ла Репюблик", population: 850),
                            Street(id: UUID(), name: "Рю Виктор Гюго", population: 700),
                            Street(id: UUID(), name: "Рю Мерсьер", population: 600)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Италия",
                population: 59550000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Рим",
                        population: 2873000,
                        streets: [
                            Street(id: UUID(), name: "Виа дель Корсо", population: 2100),
                            Street(id: UUID(), name: "Виа Венето", population: 1200),
                            Street(id: UUID(), name: "Виа Национале", population: 1500)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Милан",
                        population: 1395000,
                        streets: [
                            Street(id: UUID(), name: "Виа Монтенаполеоне", population: 900),
                            Street(id: UUID(), name: "Корсо Буэнос-Айрес", population: 1300),
                            Street(id: UUID(), name: "Виа Данте", population: 1100)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Неаполь",
                        population: 959000,
                        streets: [
                            Street(id: UUID(), name: "Виа Толедо", population: 1400),
                            Street(id: UUID(), name: "Спакканаполи", population: 950),
                            Street(id: UUID(), name: "Виа Караччоло", population: 800)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Испания",
                population: 47350000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Мадрид",
                        population: 3266000,
                        streets: [
                            Street(id: UUID(), name: "Гран-Виа", population: 2300),
                            Street(id: UUID(), name: "Пасео де ла Кастельяна", population: 1800),
                            Street(id: UUID(), name: "Калле де Алкала", population: 1600)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Барселона",
                        population: 1620000,
                        streets: [
                            Street(id: UUID(), name: "Лас-Рамблас", population: 2700),
                            Street(id: UUID(), name: "Пасео де Грасия", population: 1500),
                            Street(id: UUID(), name: "Авенида Диагональ", population: 1900)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Валенсия",
                        population: 791000,
                        streets: [
                            Street(id: UUID(), name: "Калле де ла Па", population: 1100),
                            Street(id: UUID(), name: "Авенида дель Сид", population: 850),
                            Street(id: UUID(), name: "Калле Колон", population: 950)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Великобритания",
                population: 67220000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Лондон",
                        population: 8982000,
                        streets: [
                            Street(id: UUID(), name: "Оксфорд-стрит", population: 3200),
                            Street(id: UUID(), name: "Риджент-стрит", population: 1800),
                            Street(id: UUID(), name: "Пикадилли", population: 2100)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Манчестер",
                        population: 547000,
                        streets: [
                            Street(id: UUID(), name: "Маркет-стрит", population: 1300),
                            Street(id: UUID(), name: "Динсгейт", population: 1100),
                            Street(id: UUID(), name: "Кинг-стрит", population: 900)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Ливерпуль",
                        population: 498000,
                        streets: [
                            Street(id: UUID(), name: "Черч-стрит", population: 950),
                            Street(id: UUID(), name: "Болд-стрит", population: 750),
                            Street(id: UUID(), name: "Лорд-стрит", population: 850)
                        ]
                    )
                ]
            )
        ]
    }
    
    func getData2() async throws -> [Country] {
        [
            Country(
                id: UUID(),
                name: "Япония",
                population: 125800000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Токио",
                        population: 13960000,
                        streets: [
                            Street(id: UUID(), name: "Гиндза", population: 2800),
                            Street(id: UUID(), name: "Синдзюку", population: 3200),
                            Street(id: UUID(), name: "Сибуя", population: 2500)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Осака",
                        population: 2691000,
                        streets: [
                            Street(id: UUID(), name: "Дотонбори", population: 1900),
                            Street(id: UUID(), name: "Синсайбаси", population: 1600),
                            Street(id: UUID(), name: "Умэда", population: 1400)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Киото",
                        population: 1468000,
                        streets: [
                            Street(id: UUID(), name: "Понто-тё", population: 850),
                            Street(id: UUID(), name: "Сидзё-дори", population: 1200),
                            Street(id: UUID(), name: "Киёмидзу-дзака", population: 700)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Канада",
                population: 38010000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Торонто",
                        population: 2930000,
                        streets: [
                            Street(id: UUID(), name: "Янг-стрит", population: 2100),
                            Street(id: UUID(), name: "Блур-стрит", population: 1600),
                            Street(id: UUID(), name: "Квин-стрит", population: 1400)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Монреаль",
                        population: 1705000,
                        streets: [
                            Street(id: UUID(), name: "Рю Сен-Дени", population: 1200),
                            Street(id: UUID(), name: "Рю Сен-Катрин", population: 1500),
                            Street(id: UUID(), name: "Бульвар Сен-Лоран", population: 1100)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Ванкувер",
                        population: 631000,
                        streets: [
                            Street(id: UUID(), name: "Робсон-стрит", population: 1300),
                            Street(id: UUID(), name: "Гранвиль-стрит", population: 1100),
                            Street(id: UUID(), name: "Дэви-стрит", population: 900)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Бразилия",
                population: 213300000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Сан-Паулу",
                        population: 12330000,
                        streets: [
                            Street(id: UUID(), name: "Авенида Паулиста", population: 2700),
                            Street(id: UUID(), name: "Руа Оскар Фрейре", population: 1500),
                            Street(id: UUID(), name: "Авенида Бригадейру Фария Лима", population: 1900)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Рио-де-Жанейро",
                        population: 6748000,
                        streets: [
                            Street(id: UUID(), name: "Авенида Атлантика", population: 1800),
                            Street(id: UUID(), name: "Руа Висконде де Пиража", population: 1400),
                            Street(id: UUID(), name: "Авенида Носса Сеньора де Копакабана", population: 1600)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Бразилиа",
                        population: 3055000,
                        streets: [
                            Street(id: UUID(), name: "Эйшо Монументал", population: 1100),
                            Street(id: UUID(), name: "Авенида В-3 Суд", population: 900),
                            Street(id: UUID(), name: "СКН", population: 800)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Австралия",
                population: 25690000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Сидней",
                        population: 5312000,
                        streets: [
                            Street(id: UUID(), name: "Джордж-стрит", population: 1900),
                            Street(id: UUID(), name: "Питт-стрит", population: 1600),
                            Street(id: UUID(), name: "Каслрей-стрит", population: 1200)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Мельбурн",
                        population: 5078000,
                        streets: [
                            Street(id: UUID(), name: "Свонстон-стрит", population: 1700),
                            Street(id: UUID(), name: "Бурк-стрит", population: 1400),
                            Street(id: UUID(), name: "Коллинз-стрит", population: 1500)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Брисбен",
                        population: 2480000,
                        streets: [
                            Street(id: UUID(), name: "Куин-стрит", population: 1300),
                            Street(id: UUID(), name: "Эдвард-стрит", population: 1100),
                            Street(id: UUID(), name: "Аделаида-стрит", population: 1000)
                        ]
                    )
                ]
            ),
            Country(
                id: UUID(),
                name: "Южная Корея",
                population: 51780000,
                cities: [
                    City(
                        id: UUID(),
                        name: "Сеул",
                        population: 9733000,
                        streets: [
                            Street(id: UUID(), name: "Мёндон", population: 2600),
                            Street(id: UUID(), name: "Инсадон", population: 1200),
                            Street(id: UUID(), name: "Гангнам", population: 1900)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Пусан",
                        population: 3396000,
                        streets: [
                            Street(id: UUID(), name: "Кванган-ро", population: 1500),
                            Street(id: UUID(), name: "Нампо-дон", population: 1100),
                            Street(id: UUID(), name: "Хэундэ", population: 1300)
                        ]
                    ),
                    City(
                        id: UUID(),
                        name: "Инчхон",
                        population: 2936000,
                        streets: [
                            Street(id: UUID(), name: "Чайна-таун", population: 900),
                            Street(id: UUID(), name: "Сондо", population: 1400),
                            Street(id: UUID(), name: "Бупиён", population: 1100)
                        ]
                    )
                ]
            )
        ]
    }
    
}
