`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] lo;
    reg [35:0] u;
    reg [17:0] up;
    wire sat_mode;
    wire [35:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lo(lo),
        .u(u),
        .up(up),
        .sat_mode(sat_mode),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Input within range (zero)", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = 36'sd0;
            #1;

            check_outputs(1'b0, 36'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Input within range (positive)", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = 36'sd500;
            #1;

            check_outputs(1'b0, 36'sd500);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Input within range (negative)", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = -36'sd500;
            #1;

            check_outputs(1'b0, -36'sd500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Saturation High", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = 36'sd1500;
            #1;

            check_outputs(1'b1, 36'sd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Saturation Low", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = -36'sd1500;
            #1;

            check_outputs(1'b1, -36'sd1000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Boundary Condition (u == up)", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = 36'sd1000;
            #1;

            check_outputs(1'b0, 36'sd1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Boundary Condition (u == lo)", test_num);
            up = 18'sd1000;
            lo = -18'sd1000;
            u = -36'sd1000;
            #1;

            check_outputs(1'b0, -36'sd1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Extreme 36-bit Positive value", test_num);
            up = 18'sh1FFFF;
            lo = 18'sh20000;
            u = 36'h7FFFFFFFF;
            #1;

            check_outputs(1'b1, 36'sh00001FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Extreme 36-bit Negative value", test_num);
            up = 18'sh1FFFF;
            lo = 18'sh20000;
            u = 36'h800000000;
            #1;

            check_outputs(1'b1, 36'hFFFFE0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Negative limits range (up and lo are both negative)", test_num);
            up = -18'sd50;
            lo = -18'sd100;
            u = -36'sd75;
            #1;

            check_outputs(1'b0, -36'sd75);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("\nTestcase %0d: Positive limits range (u below positive range)", test_num);
            up = 18'sd200;
            lo = 18'sd100;
            u = 36'sd50;
            #1;

            check_outputs(1'b1, 36'sd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_sat_mode;
        input [35:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sat_mode === (expected_sat_mode ^ sat_mode ^ expected_sat_mode) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: sat_mode=%b, y=%h",
                         sat_mode, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sat_mode=%b, y=%h",
                         expected_sat_mode, expected_y);
                $display("  Got:      sat_mode=%b, y=%h",
                         sat_mode, y);
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
