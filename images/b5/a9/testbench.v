`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] div;
    reg [31:0] dor;
    wire [31:0] quo;
    wire [31:0] rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .div(div),
        .dor(dor),
        .quo(quo),
        .rem(rem)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard Division (100 / 10)", test_num);
            div = 32'd100;
            dor = 32'd10;
            #1;

            check_outputs(32'd10, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division with remainder (17 / 5)", test_num);
            div = 32'd17;
            dor = 32'd5;
            #1;

            check_outputs(32'd3, 32'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by zero", test_num);
            div = 32'd500;
            dor = 32'd0;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend is zero", test_num);
            div = 32'd0;
            dor = 32'd25;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Divisor larger than Dividend (5 / 10)", test_num);
            div = 32'd5;
            dor = 32'd10;
            #1;

            check_outputs(32'd0, 32'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend equals Divisor", test_num);
            div = 32'hABCDE;
            dor = 32'hABCDE;
            #1;

            check_outputs(32'd1, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max 32-bit Dividend / 2", test_num);
            div = 32'hFFFFFFFF;
            dor = 32'd2;
            #1;

            check_outputs(32'h7FFFFFFF, 32'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by 1", test_num);
            div = 32'd1234567;
            dor = 32'd1;
            #1;

            check_outputs(32'd1234567, 32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Divisor", test_num);
            div = 32'hFFFFFFFF;
            dor = 32'hFFFFFFFE;
            #1;

            check_outputs(32'd1, 32'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 divided by 0", test_num);
            div = 32'd0;
            dor = 32'd0;
            #1;

            check_outputs(32'd0, 32'd0);
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
        input [31:0] expected_quo;
        input [31:0] expected_rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quo === (expected_quo ^ quo ^ expected_quo) &&
                expected_rem === (expected_rem ^ rem ^ expected_rem)) begin
                $display("PASS");
                $display("  Outputs: quo=%h, rem=%h",
                         quo, rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quo=%h, rem=%h",
                         expected_quo, expected_rem);
                $display("  Got:      quo=%h, rem=%h",
                         quo, rem);
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
