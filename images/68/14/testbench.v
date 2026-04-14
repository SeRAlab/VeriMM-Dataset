`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] denom;
    reg [7:0] numer;
    wire [7:0] quotient;
    wire [7:0] remain;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .denom(denom),
        .numer(numer),
        .quotient(quotient),
        .remain(remain)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple division (no remainder)", test_num);
            numer = 8'd20;
            denom = 8'd4;
            #1;

            check_outputs(8'd5, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple division (with remainder)", test_num);
            numer = 8'd20;
            denom = 8'd3;
            #1;

            check_outputs(8'd6, 8'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dividend is zero", test_num);
            numer = 8'd0;
            denom = 8'd10;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Divisor greater than dividend", test_num);
            numer = 8'd5;
            denom = 8'd10;
            #1;

            check_outputs(8'd0, 8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by one", test_num);
            numer = 8'd255;
            denom = 8'd1;
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Divide by self", test_num);
            numer = 8'd128;
            denom = 8'd128;
            #1;

            check_outputs(8'd1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum dividend and small divisor", test_num);
            numer = 8'd255;
            denom = 8'd2;
            #1;

            check_outputs(8'd127, 8'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Prime number division", test_num);
            numer = 8'd123;
            denom = 8'd11;
            #1;

            check_outputs(8'd11, 8'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division resulting in 2", test_num);
            numer = 8'd254;
            denom = 8'd127;
            #1;

            check_outputs(8'd2, 8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum values", test_num);
            numer = 8'd255;
            denom = 8'd255;
            #1;

            check_outputs(8'd1, 8'd0);
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
        input [7:0] expected_quotient;
        input [7:0] expected_remain;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remain === (expected_remain ^ remain ^ expected_remain)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remain=%h",
                         quotient, remain);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remain=%h",
                         expected_quotient, expected_remain);
                $display("  Got:      quotient=%h, remain=%h",
                         quotient, remain);
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
