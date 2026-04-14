`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    reg [7:0] x4;
    reg [7:0] y0;
    reg [7:0] y1;
    reg [7:0] y2;
    reg [7:0] y3;
    reg [7:0] y4;
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
            $display("\nTest Case %0d: Horizontal line y=5", test_num);
            x0 = 8'd1; x1 = 8'd2; x2 = 8'd3; x3 = 8'd4; x4 = 8'd5;
            y0 = 8'd5; y1 = 8'd5; y2 = 8'd5; y3 = 8'd5; y4 = 8'd5;
            #1;

            check_outputs(16'h0005, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity line y=x", test_num);
            x0 = 8'd1; x1 = 8'd2; x2 = 8'd3; x3 = 8'd4; x4 = 8'd5;
            y0 = 8'd1; y1 = 8'd2; y2 = 8'd3; y3 = 8'd4; y4 = 8'd5;
            #1;

            check_outputs(16'h0000, 16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear line y=2x+10", test_num);
            x0 = 8'd0; x1 = 8'd1; x2 = 8'd2; x3 = 8'd3; x4 = 8'd4;
            y0 = 8'd10; y1 = 8'd12; y2 = 8'd14; y3 = 8'd16; y4 = 8'd18;
            #1;

            check_outputs(16'h000A, 16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative slope y=-x+20", test_num);
            x0 = 8'd2; x1 = 8'd4; x2 = 8'd6; x3 = 8'd8; x4 = 8'd10;
            y0 = 8'd18; y1 = 8'd16; y2 = 8'd14; y3 = 8'd12; y4 = 8'd10;
            #1;

            check_outputs(16'h0014, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger coordinates y=3x+10", test_num);
            x0 = 8'd10; x1 = 8'd20; x2 = 8'd30; x3 = 8'd40; x4 = 8'd50;
            y0 = 8'd40; y1 = 8'd70; y2 = 8'd100; y3 = 8'd130; y4 = 8'd160;
            #1;

            check_outputs(16'h000A, 16'h0003);
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
