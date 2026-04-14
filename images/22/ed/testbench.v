`timescale 1ns/1ps

module png_paeth_predictor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] above_left_pixel;
    reg [7:0] above_pixel;
    reg [7:0] current_pixel;
    reg [7:0] left_pixel;
    wire [7:0] predicted_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_paeth_predictor dut (
        .above_left_pixel(above_left_pixel),
        .above_pixel(above_pixel),
        .current_pixel(current_pixel),
        .left_pixel(left_pixel),
        .predicted_pixel(predicted_pixel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All input pixels identical", test_num);
        above_left_pixel = 8'd128;
        above_pixel = 8'd128;
        left_pixel = 8'd128;
        current_pixel = 8'd0;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Horizontal correlation (a != b, b == c)", test_num);
        above_left_pixel = 8'd50;
        above_pixel = 8'd50;
        left_pixel = 8'd150;
        current_pixel = 8'd0;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Vertical correlation (b != a, a == c)", test_num);
        above_left_pixel = 8'd50;
        above_pixel = 8'd150;
        left_pixel = 8'd50;
        current_pixel = 8'd0;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Above-Left pixel is best predictor", test_num);
        above_left_pixel = 8'd15;
        above_pixel = 8'd20;
        left_pixel = 8'd10;
        current_pixel = 8'd0;

        #1;


        check_outputs(8'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Tie-breaker pa == pb (should pick left)", test_num);
        above_left_pixel = 8'd50;
        above_pixel = 8'd100;
        left_pixel = 8'd100;
        current_pixel = 8'd0;

        #1;


        check_outputs(8'd100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Extreme values (255, 0)", test_num);
        above_left_pixel = 8'd0;
        above_pixel = 8'd255;
        left_pixel = 8'd255;
        current_pixel = 8'd0;

        #1;


        check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Opposite extremes", test_num);
        above_left_pixel = 8'd255;
        above_pixel = 8'd255;
        left_pixel = 8'd0;
        current_pixel = 8'd0;

        #1;


        check_outputs(8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_paeth_predictor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_predicted_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_predicted_pixel === (expected_predicted_pixel ^ predicted_pixel ^ expected_predicted_pixel)) begin
                $display("PASS");
                $display("  Outputs: predicted_pixel=%h",
                         predicted_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_pixel=%h",
                         expected_predicted_pixel);
                $display("  Got:      predicted_pixel=%h",
                         predicted_pixel);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
