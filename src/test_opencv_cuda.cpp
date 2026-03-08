// test_opencv_cuda.cpp
#include <opencv2/opencv.hpp>
#include <opencv2/cudawarping.hpp>
#include <opencv2/cudaarithm.hpp>
#include <iostream>

int main() {
    // --- CPU: Create the source image ---
    cv::Mat image(480, 640, CV_8UC3, cv::Scalar(255, 255, 255));

    // Draw a blue border
    cv::rectangle(image, cv::Rect(0, 0, 640, 480), cv::Scalar(255, 0, 0), 5);

    // Draw centered green "Hello World" text
    std::string text = "Hello World";
    int font = cv::FONT_HERSHEY_SIMPLEX;
    double font_scale = 1.0;
    cv::Scalar text_color(0, 255, 0); // Green (BGR)
    int thickness = 2;
    int baseline = 0;
    cv::Size text_size = cv::getTextSize(text, font, font_scale, thickness, &baseline);
    int x = (image.cols - text_size.width) / 2;
    int y = (image.rows + text_size.height) / 2;
    cv::putText(image, text, cv::Point(x, y), font, font_scale, text_color, thickness);

    // --- CUDA: Upload → rotate 90° counter-clockwise → download ---
    std::cout << "Uploading image to GPU..." << std::endl;
    cv::cuda::GpuMat gpu_src, gpu_rotated;
    gpu_src.upload(image);

    // cv::cuda::rotate() rotates by angle degrees around the source centre.
    // For 90° counter-clockwise the output size is (src.rows, src.cols) and
    // the rotation centre shifts accordingly.
    double angle = 90.0; // CCW
    cv::Size dst_size(image.rows, image.cols); // swapped width/height
    // Shift so the rotated image stays in frame:
    //   new origin = (0, src.cols - 1)  for a 90° CCW rotation
    double shift_x = 0.0;
    double shift_y = static_cast<double>(image.cols - 1);
    cv::cuda::rotate(gpu_src, gpu_rotated, dst_size, angle, shift_x, shift_y);

    std::cout << "90° CCW rotation complete on GPU." << std::endl;

    // Download result back to CPU
    cv::Mat rotated;
    gpu_rotated.download(rotated);

    // --- Save image ---
    cv::imwrite("foo_rotated.jpg", rotated);

    // --- Display (requires X11 / display server) ---
    cv::imshow("Rotated 90 CCW using CUDA", rotated);
    cv::waitKey(0);

    return 0;
}