`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] div;
    reg [31:0] divisor;
    wire [31:0] rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .div(div),
        .divisor(divisor),
        .rem(rem)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard modulo (10 %% 3)", test_num);
            div = 32'd10;
            divisor = 32'd3;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Division by zero (10 %% 0)", test_num);
            div = 32'd10;
            divisor = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dividend < Divisor (5 %% 12)", test_num);
            div = 32'd5;
            divisor = 32'd12;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exact division (100 %% 10)", test_num);
            div = 32'd100;
            divisor = 32'd10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max values (0xFFFFFFFF %% 2)", test_num);
            div = 32'hFFFFFFFF;
            divisor = 32'd2;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of 2 divisor (0xABCDE %% 0x100)", test_num);
            div = 32'hABCDE;
            divisor = 32'h100;
            #1;

            check_outputs(32'hDE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large dividend and divisor", test_num);
            div = 32'd1000000;
            divisor = 32'd7;
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dividend equals divisor", test_num);
            div = 32'h12345678;
            divisor = 32'h12345678;
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rem === (expected_rem ^ rem ^ expected_rem)) begin
                $display("PASS");
                $display("  Outputs: rem=%h",
                         rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rem=%h",
                         expected_rem);
                $display("  Got:      rem=%h",
                         rem);
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
