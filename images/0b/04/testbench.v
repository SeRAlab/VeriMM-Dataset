`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    reg [15:0] x4;
    reg [15:0] y0;
    reg [15:0] y1;
    reg [15:0] y2;
    reg [15:0] y3;
    reg [15:0] y4;
    wire [15:0] intercept;
    wire [15:0] slope;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .intercept(intercept),
        .slope(slope)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity function y = x (m=1, b=0)", test_num);

            x0 = 16'd0; x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4;
            y0 = 16'd0; y1 = 16'd1; y2 = 16'd2; y3 = 16'd3; y4 = 16'd4;
            #1;

            check_outputs(16'd0, 16'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal line y = 5 (m=0, b=5)", test_num);

            x0 = 16'd0; x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4;
            y0 = 16'd5; y1 = 16'd5; y2 = 16'd5; y3 = 16'd5; y4 = 16'd5;
            #1;

            check_outputs(16'd5, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive slope and intercept y = 2x + 10", test_num);

            x0 = 16'd0; x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4;
            y0 = 16'd10; y1 = 16'd12; y2 = 16'd14; y3 = 16'd16; y4 = 16'd18;
            #1;

            check_outputs(16'd10, 16'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Steeper slope y = 5x + 1", test_num);

            x0 = 16'd1; x1 = 16'd2; x2 = 16'd3; x3 = 16'd4; x4 = 16'd5;
            y0 = 16'd6; y1 = 16'd11; y2 = 16'd16; y3 = 16'd21; y4 = 16'd26;
            #1;

            check_outputs(16'd1, 16'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large intercept y = 3x + 100", test_num);

            x0 = 16'd1; x1 = 16'd2; x2 = 16'd3; x3 = 16'd4; x4 = 16'd5;
            y0 = 16'd103; y1 = 16'd106; y2 = 16'd109; y3 = 16'd112; y4 = 16'd115;
            #1;

            check_outputs(16'd100, 16'd3);
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
        input [15:0] expected_intercept;
        input [15:0] expected_slope;
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
