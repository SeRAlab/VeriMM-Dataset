`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    reg [15:0] x4;
    reg [15:0] x5;
    reg [15:0] y1;
    reg [15:0] y2;
    reg [15:0] y3;
    reg [15:0] y4;
    reg [15:0] y5;
    wire [15:0] intercept;
    wire [15:0] slope;

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
        $display("Test Case %0d: Horizontal Line (y = 5)", test_num);

        x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4; x5 = 16'd5;

        y1 = 16'd5; y2 = 16'd5; y3 = 16'd5; y4 = 16'd5; y5 = 16'd5;

        #1;


        check_outputs(16'd5, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Line (y = x)", test_num);

        x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4; x5 = 16'd5;

        y1 = 16'd1; y2 = 16'd2; y3 = 16'd3; y4 = 16'd4; y5 = 16'd5;

        #1;


        check_outputs(16'd0, 16'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Slope with Offset (y = 2x + 3)", test_num);

        x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4; x5 = 16'd5;

        y1 = 16'd5; y2 = 16'd7; y3 = 16'd9; y4 = 16'd11; y5 = 16'd13;

        #1;


        check_outputs(16'd3, 16'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative Slope (y = -x + 10)", test_num);

        x1 = 16'd1; x2 = 16'd2; x3 = 16'd3; x4 = 16'd4; x5 = 16'd5;

        y1 = 16'd9; y2 = 16'd8; y3 = 16'd7; y4 = 16'd6; y5 = 16'd5;

        #1;


        check_outputs(16'd10, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Steep Slope (y = 10x + 5)", test_num);

        x1 = 16'd1;  x2 = 16'd2;  x3 = 16'd3;  x4 = 16'd4;  x5 = 16'd5;

        y1 = 16'd15; y2 = 16'd25; y3 = 16'd35; y4 = 16'd45; y5 = 16'd55;

        #1;


        check_outputs(16'd5, 16'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Negative Slope (y = -2x + 20)", test_num);

        x1 = 16'd1;  x2 = 16'd2;  x3 = 16'd3;  x4 = 16'd4;  x5 = 16'd5;

        y1 = 16'd18; y2 = 16'd16; y3 = 16'd14; y4 = 16'd12; y5 = 16'd10;

        #1;


        check_outputs(16'd20, 16'hFFFE);
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
        testcase006();
        
        
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
