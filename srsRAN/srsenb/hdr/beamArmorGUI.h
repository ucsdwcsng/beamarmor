#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Chart.H>

#include <iostream>
#include <thread>
#include <atomic>
#include <chrono>

extern double bler;
extern double sinr;
extern double throughput;

void updateWindow(Fl_Chart *barChart1, Fl_Chart *barChart2, Fl_Chart *barChart3) {
    while (true)
    {
        barChart1->replace(1, bler, "BLER", FL_DARK_RED);
        barChart2->replace(1, sinr, "SINR", FL_DARK_GREEN);
        barChart3->replace(1, throughput, "Throughput", FL_DARK_GREEN);

        barChart1->redraw();
        barChart2->redraw();
        barChart3->redraw();
        Fl::flush();

        std::this_thread::sleep_for(std::chrono::milliseconds(200));
    }    
}

void initBarChart(Fl_Chart *barChart, const char *metric) {
    barChart->color(FL_WHITE); // Set the background color
    barChart->type(FL_BAR_CHART);
    barChart->textfont(FL_BOLD);
    barChart->textsize(12);

    barChart->bounds(0, 100);

    // Set initial random value for the bar chart
    barChart->add(42, metric, 84);
}

void start_beamArmorGUI() {
    // Create an FLTK window
    Fl_Window *window = new Fl_Window(400, 300, "BeamArmor Metrics");

    // Create bar charts
    Fl_Chart *barChart1 = new Fl_Chart(10, 10, 120, 280);
    Fl_Chart *barChart2 = new Fl_Chart(140, 10, 120, 280);
    Fl_Chart *barChart3 = new Fl_Chart(270, 10, 120, 280);

    // Init bar charts values
    initBarChart(barChart1, "BLER");
    initBarChart(barChart2, "SINR");
    initBarChart(barChart3, "Throughput");

    // Show the window
    window->end();
    window->show();

    std::thread displayThread(updateWindow, barChart1, barChart2, barChart3);

    Fl::run();

    displayThread.join();
}