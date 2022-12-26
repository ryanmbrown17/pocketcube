An introduction to Group Theory will often include references to the Rubik’s Group. The Rubik’s Group has elements defined by letters representing moves performed on a Rubik’s Cube, where sets of moves resulting in the same cube will be considered the same element. In-depth analysis is often not done, partly due to the cardinality of over 43 quintillion. A more manageable cardinality of just over 3 million is held by the Pocket Rubik’s Group, which can be defined similarly to the Rubik’s Group but with a 2x2x2 Cube. The group was generated using GAP, a system for computational discrete algebra. Utilizing the quarter-turn metric, treating a ? radian rotation as two turns, an adjacency matrix was produced, and the diameter of the Pocket Rubik’s Group was confirmed to be 14. The group is defined by cyclic generators for programming efficiency. The group is also defined as a free group of 3 generators and a set of relations. Exploring the symmetry, the elements in the group can further be condensed. As associativity fails, the Pocket Rubik’s Group fails to be a group under additional symmetry. Utilizing the symmetry, however, allows a simplified graph to be generated, which more succinctly presents the behavior of the group when compared to the Cayley Graph. The adjacency matrix can be transformed into a stochastic matrix, which will then be utilized for Markov chain analysis to understand better how quickly some mixing algorithms for the cube will disperse and answer the question by many cube enthusiasts: When is a cube properly mixed?

Starting as a senior seminar project, then progressing to department-sponsored independent research, I explored the question of "when is a 2x2x2 properly mixed?" from a mathematical perspective. This culminated with a chance to present my work at the Young Mathematician's Conference at The Ohio State University.

This repository stores some of the work associated with my senior seminar, completed in spring 2022, and continued work on the topic over that summer.  

The seminar report can be found at:  Senior_Seminar-1

The report after the summer can be found: Continued Exploration of the Pocket Cube

The presentation poster is:  cube_poster


The work started in Julia trying to study the cube utilizing symmetries similar to the work done by Tomas Rokicki et al in "The Diameter of the Rubik's Cube Group is Twenty".  This turned out to be too computationally expensive, so a pivot was taken in the project.  The GAP program helped to generate the states of the cubes and relations, the CPP code was used to edit and manipulate the data collected into useful files, and the python was used for analysis. 
