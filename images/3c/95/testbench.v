`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] x3;
    reg [31:0] x4;
    reg [31:0] x5;
    reg [31:0] y1;
    reg [31:0] y2;
    reg [31:0] y3;
    reg [31:0] y4;
    reg [31:0] y5;
    wire [31:0] intercept;
    wire [31:0] slope;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .y5(y5),
        .intercept(intercept),
        .slope(slope)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: y = x (Slope: 1, Intercept: 0)", test_num);
            x1 = 1; x2 = 2; x3 = 3; x4 = 4; x5 = 5;
            y1 = 1; y2 = 2; y3 = 3; y4 = 4; y5 = 5;




            #1;





            check_outputs(32'd0, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: y = 2x + 10 (Slope: 2, Intercept: 10)", test_num);
            x1 = 1; x2 = 2; x3 = 3; x4 = 4; x5 = 5;
            y1 = 12; y2 = 14; y3 = 16; y4 = 18; y5 = 20;




            #1;





            check_outputs(32'd10, 32'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Slope (y = -1x + 5)", test_num);
            x1 = 1; x2 = 2; x3 = 3; x4 = 4; x5 = 5;
            y1 = 4; y2 = 3; y3 = 2; y4 = 1; y5 = 0;




            #1;





            check_outputs(32'd5, -32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal Line (y = 0x + 7)", test_num);
            x1 = 1; x2 = 2; x3 = 3; x4 = 4; x5 = 5;
            y1 = 7; y2 = 7; y3 = 7; y4 = 7; y5 = 7;




            #1;





            check_outputs(32'd7, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Intercept (y = 3x - 2)", test_num);
            x1 = 1; x2 = 2; x3 = 3; x4 = 4; x5 = 5;
            y1 = 1; y2 = 4; y3 = 7; y4 = 10; y5 = 13;




            #1;





            check_outputs(-32'd2, 32'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_intercept;
        input [31:0] expected_slope;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_intercept === (expected_intercept ^ intercept ^ expected_intercept) &&
                expected_slope === (expected_slope ^ slope ^ expected_slope)) begin
                $display("PASS");
                $display("  Outputs: intercept=%h, slope=%h",
                         intercept, slope);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intercept=%h, slope=%h",
                         expected_intercept, expected_slope);
                $display("  Got:      intercept=%h, slope=%h",
                         intercept, slope);
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
