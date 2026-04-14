`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    reg [31:0] y;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division by zero (y=0)", test_num);
            x = 32'h12345678;
            y = 32'h0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x < y (remainder should be x)", test_num);
            x = 32'd15;
            y = 32'd50;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x == y (remainder should be 0)", test_num);
            x = 32'd100;
            y = 32'd100;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard modulo (10 mod 3)", test_num);
            x = 32'd10;
            y = 32'd3;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact division (100 mod 10)", test_num);
            x = 32'd100;
            y = 32'd10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dividend is zero (0 mod 5)", test_num);
            x = 32'd0;
            y = 32'd5;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Modulo by 1", test_num);
            x = 32'hFFFFFFFF;
            y = 32'd1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large numbers modulo", test_num);
            x = 32'd4294967295;
            y = 32'd10;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large divisor", test_num);
            x = 32'd1000000;
            y = 32'd999999;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime modulo", test_num);
            x = 32'd1234567;
            y = 32'd7;
            #1;

            check_outputs(32'd1234567 % 32'd7);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
