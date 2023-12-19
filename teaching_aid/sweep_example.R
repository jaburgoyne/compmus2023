# Code to make sweep test example

# assuming merged the sweep function, re-install
# install_github("jaburgoyne/compmus")
# adds
# library(ggpubr)
# library(furrr)

library(tidyverse)
library(tidymodels)
library(plotly)
library(heatmaply)
library(protoclust)
library(cowplot)
library(spotifyr)
library(compmus)

# Set up access keys!

#Sys.setenv(SPOTIFY_CLIENT_ID = 'xxx')
#Sys.setenv(SPOTIFY_CLIENT_SECRET = 'xxx')

access_token <- get_spotify_access_token()

# make a plot

just <-
  get_tidy_audio_analysis("1dyTcli07c77mtQK3ahUZR?si=11d5b848bcf546e7") |>
  select(segments) |>
  unnest(segments) |>
  select(start, duration, pitches)

just_plot <-
  just |>
  mutate(pitches = map(pitches, compmus_normalise, "euclidean")) |>
  compmus_gather_chroma() |>
  filter(start < 25) |>
  ggplot(
    aes(
      x = start + duration / 2,
      width = duration,
      y = pitch_class,
      fill = value
    )
  ) +
  geom_tile() +
  labs(
    x = "Time (s)",
    y = NULL,
    fill = "Magnitude",
    title = "Just (Radiohead)",
    subtitle = "First 25 seconds"
  ) +
  theme_minimal() +
  scale_fill_viridis_c()

just_plot

create_sweep_video(plot = just_plot,
                       x_start = 0,
                       x_end = 25,
                       duration = 25,
                       output_path = "teaching_aid/just_sweep.mp4",
                       audio_path = "teaching_aid/rhji.wav")
