//
// Project.swift
// BlockUser
//
// Created by summercat on 2025/02/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
  name: Modules.Presentation.BlockUser.rawValue,
  dependencies: [
    .domain(target: .Entities),
    .domain(target: .UseCases),
    .presentation(target: .DesignSystem),
    .presentation(target: .Router),
  ]
)
