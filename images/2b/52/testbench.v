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
            $display("\nTest Case %0d: Identity Line (y = x)", test_num);
            x0 = 16'h0000; y0 = 16'h0000;
            x1 = 16'h0001; y1 = 16'h0001;
            x2 = 16'h0002; y2 = 16'h0002;
            x3 = 16'h0003; y3 = 16'h0003;
            x4 = 16'h0004; y4 = 16'h0004;
            #1;

            check_outputs(16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Line (y = 5)", test_num);
            x0 = 16'h0000; y0 = 16'h0005;
            x1 = 16'h0001; y1 = 16'h0005;
            x2 = 16'h0002; y2 = 16'h0005;
            x3 = 16'h0003; y3 = 16'h0005;
            x4 = 16'h0004; y4 = 16'h0005;
            #1;

            check_outputs(16'h0005, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear with Offset (y = 2x + 3)", test_num);
            x0 = 16'h0000; y0 = 16'h0003;
            x1 = 16'h0001; y1 = 16'h0005;
            x2 = 16'h0002; y2 = 16'h0007;
            x3 = 16'h0003; y3 = 16'h0009;
            x4 = 16'h0004; y4 = 16'h000B;
            #1;

            check_outputs(16'h0003, 16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Slope (y = -x + 10)", test_num);
            x0 = 16'h0000; y0 = 16'h000A;
            x1 = 16'h0001; y1 = 16'h0009;
            x2 = 16'h0002; y2 = 16'h0008;
            x3 = 16'h0003; y3 = 16'h0007;
            x4 = 16'h0004; y4 = 16'h0006;
            #1;

            check_outputs(16'h000A, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Line through origin (y = 4x)", test_num);
            x0 = 16'h0001; y0 = 16'h0004;
            x1 = 16'h0002; y1 = 16'h0008;
            x2 = 16'h0003; y2 = 16'h000C;
            x3 = 16'h0004; y3 = 16'h0010;
            x4 = 16'h0005; y4 = 16'h0014;
            #1;

            check_outputs(16'h0000, 16'h0004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Y values zero", test_num);
            x0 = 16'h0001; y0 = 16'h0000;
            x1 = 16'h0002; y1 = 16'h0000;
            x2 = 16'h0003; y2 = 16'h0000;
            x3 = 16'h0004; y3 = 16'h0000;
            x4 = 16'h0005; y4 = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
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
