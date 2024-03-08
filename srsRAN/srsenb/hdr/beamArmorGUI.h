#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Chart.H>
// #include <matplot/matplot.h>
#include <gnuplot-iostream.h>
#include <iostream>
#include <thread>
#include <atomic>
#include <chrono>

extern double bler;
extern double sinr;
extern double throughput;
// double a = 0; 

std::vector<double> bler_vector;
std::vector<double> sinr_vector;
std::vector<double> tput_vector;
Gnuplot gp;
Gnuplot bler_plot;
Gnuplot sinr_plot;
Gnuplot tput_plot;

// using namespace matplot;

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

    if (strcmp(metric, "BLER") == 0)
    {
        barChart->bounds(0, 100);
    }
    else if (strcmp(metric, "SINR") == 0) {
        barChart->bounds(0, 30);
    } else {
        barChart->bounds(0, 10000);
    }

    // Set initial random value for the bar chart
    barChart->add(42, metric, 84);
}

void updatePlot(){

        // gp << "set terminal wxt size 1900,800\n";
        // gp << "set multiplot layout '1','3'\n";

        bler_plot << "set terminal wxt size 600,500 position 10,0\n";
        bler_plot << "set title 'BLER' font 'sans,38'\n";
        bler_plot << "set grid\n";
        bler_plot << "set xlabel 'Time (s)' font 'sans,25'\n";
        bler_plot << "set ylabel 'BLER (%)' font 'sans,25'\n";
        bler_plot << "set xrange [0:200]\nset yrange [0:100]\n";
        bler_plot << "set xtics 20\n";

        sinr_plot << "set terminal wxt size 600,500 position 685,0\n";
        sinr_plot << "set title 'SINR' font 'sans,38'\n";
        sinr_plot << "set grid\n";
        sinr_plot << "set xlabel 'Time (s)' font 'sans,25'\n";
        sinr_plot << "set ylabel 'SINR (dB)' font 'sans,25'\n";
        sinr_plot << "set xrange [0:200]\nset yrange [0:50]\n";
        sinr_plot << "set xtics 20\n";

        tput_plot << "set terminal wxt size 600,500 position 1300,0\n";
        tput_plot << "set title 'Throughput' font 'sans,38'\n";
        tput_plot << "set grid\n";
        tput_plot << "set xlabel 'Time (s)' font 'sans,25'\n";
        tput_plot << "set ylabel 'Throughput (Mbps)' font 'sans,25'\n";
        tput_plot << "set xrange [0:200]\nset yrange [0:25]\n";
        tput_plot << "set xtics 20\n";

    while (true){
        if (tput_vector.size() == 200){
            tput_vector.erase(tput_vector.begin(), tput_vector.begin() + 200);
            sinr_vector.erase(sinr_vector.begin(), sinr_vector.begin() + 200);
            bler_vector.erase(bler_vector.begin(), bler_vector.begin() + 200);
        }
        bler_vector.push_back(bler);
        sinr_vector.push_back(sinr);
        tput_vector.push_back(throughput/1000000);

        // gp << "set title 'Throughput' font 'sans,40'\n";
        // gp << "set grid\n";
        // gp << "set size '0.3','1'\n";
        // gp << "set xlabel 'Time (ms)' font 'sans,25'\n";
        // gp << "set ylabel 'Throughput (Mbps)' font 'sans,25'\n";
        // gp << "set xrange [0:600]\nset yrange [0:10]\n";
        // gp << "set xtics 0,100,1000\n";
        // gp << "plot '-' with lines lw 5 lc 'blue' title 'Throughput'\n";
        // gp.send1d(tput_vector);

        // gp << "set title 'SINR' font 'sans,40'\n";
        // gp << "set grid\n";
        // gp << "set size '0.3','1'\n";
        // gp << "set xlabel 'Time (ms)' font 'sans,25'\n";
        // gp << "set ylabel 'SINR (dB)' font 'sans,25'\n";
        // gp << "set xrange [0:600]\nset yrange [0:15]\n";
        // gp << "set xtics 0,100,1000\n";
        // gp << "plot '-' with lines lw 5 lc 'green' title 'SINR'\n";
        // gp.send1d(sinr_vector);

        // gp << "set title 'BLER' font 'sans,40'\n";
        // gp << "set grid\n";
        // gp << "set size '0.3','1'\n";
        // gp << "set xlabel 'Time (ms)' font 'sans,25'\n";
        // gp << "set ylabel 'BLER (%)' font 'sans,25'\n";
        // gp << "set xrange [0:600]\nset yrange [0:100]\n";
        // gp << "set xtics 0,100,1000\n";
        // gp << "plot '-' with lines lw 5 lc 'red' title 'BLER'\n";
        // gp.send1d(bler_vector);


        tput_plot << "plot '-' with lines lw 5 lc 'blue' title 'Throughput'\n";
        tput_plot.send1d(tput_vector); 

        sinr_plot << "plot '-' with lines lw 5 lc 'green' title 'SINR'\n";
        sinr_plot.send1d(sinr_vector);

        bler_plot << "plot '-' with lines lw 5 lc 'red' title 'BLER'\n";
        bler_plot.send1d(bler_vector);

        std::this_thread::sleep_for(std::chrono::milliseconds(1000));

    }
}

void start_beamArmorGUI() {
    // // Create an FLTK window
    // Fl_Window *window = new Fl_Window(400, 300, "BeamArmor Metrics");

    // // Create bar charts
    // Fl_Chart *barChart1 = new Fl_Chart(10, 10, 120, 280);
    // Fl_Chart *barChart2 = new Fl_Chart(140, 10, 120, 280);
    // Fl_Chart *barChart3 = new Fl_Chart(270, 10, 120, 280);

    // // Init bar charts values
    // initBarChart(barChart1, "BLER");
    // initBarChart(barChart2, "SINR");
    // initBarChart(barChart3, "Throughput");

    // // Show the window
    // window->end();
    // window->show();

    // std::thread displayThread(updateWindow, barChart1, barChart2, barChart3);

    // Fl::run();

  // Create a script which can be manually fed into gnuplot later:
  //    Gnuplot gp(">script.gp");
  // Create script and also feed to gnuplot:
  //    Gnuplot gp("tee plot.gp | gnuplot -persist");
  // Or choose any of those options at runtime by setting the GNUPLOT_IOSTREAM_CMD
  // environment variable.

  // Gnuplot vectors (i.e. arrows) require four columns: (x,y,dx,dy)
//   std::vector<boost::tuple<double, double, double, double> > pts_A;

  // You can also use a separate container for each column, like so:
//   std::vector<double> pts_B_x;
//   std::vector<double> pts_B_y;
//   std::vector<double> pts_B_dx;
//   std::vector<double> pts_B_dy;

    // std::vector<double> tput; 

  // You could also use:
  //   std::vector<std::vector<double> >
  //   boost::tuple of four std::vector's
  //   std::vector of std::tuple (if you have C++11)
  //   arma::mat (with the Armadillo library)
  //   blitz::Array<blitz::TinyVector<double, 4>, 1> (with the Blitz++ library)
  // ... or anything of that sort

//   for(double alpha=0; alpha<1; alpha+=1.0/24.0) {
//     double theta = alpha*2.0*3.14159;
//     pts_A.push_back(boost::make_tuple(
//        cos(theta),
//        sin(theta),
//       -cos(theta)*0.1,
//       -sin(theta)*0.1
//     ));

//     pts_B_x .push_back( cos(theta)*0.8);
//     pts_B_y .push_back( sin(theta)*0.8);
//     pts_B_dx.push_back( sin(theta)*0.1);
//     pts_B_dy.push_back(-cos(theta)*0.1);
//   }


    // for(double i = 0; i < 100; i++){
    //     tput.push_back(i);
    // }

  // Don't forget to put "\n" at the end of each line!
//   gp << "set xrange [-2:2]\nset yrange [-2:2]\n";
//   // '-' means read from stdin.  The send1d() function sends data to gnuplot's stdin.
//   gp << "plot '-' with vectors title 'pts_A', '-' with vectors title 'pts_B'\n";
//   gp.send1d(pts_A);
//   gp.send1d(boost::make_tuple(pts_B_x, pts_B_y, pts_B_dx, pts_B_dy));

//   gp << "set xrange [0:100]\nset yrange [0:100]\n";
//   // '-' means read from stdin.  The send1d() function sends data to gnuplot's stdin.
//   gp << "plot  '-' with lines title 'tput'\n";
//   gp.send1d(tput);


#ifdef _WIN32
  // For Windows, prompt for a keystroke before the Gnuplot object goes out of scope so that
  // the gnuplot window doesn't get closed.
  std::cout << "Press enter to exit." << std::endl;
  std::cin.get();
#endif
std::thread displayThread(updatePlot);

    displayThread.join();
}