`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [5:0] alufn;
    reg [15:0] b;
    wire [15:0] com_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alufn(alufn),
        .b(b),
        .com_out(com_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality - Match", test_num);
            alufn = 6'b000010;
            a = 16'h1234;
            b = 16'h1234;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality - No Match", test_num);
            alufn = 6'b000010;
            a = 16'h1234;
            b = 16'hABCD;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Less Than - True", test_num);
            alufn = 6'b000100;
            a = 16'h0005;
            b = 16'h0010;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Less Than - False (Greater)", test_num);
            alufn = 6'b000100;
            a = 16'h0020;
            b = 16'h0010;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Less Than - False (Equal)", test_num);
            alufn = 6'b000100;
            a = 16'hFFFF;
            b = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LE - True (Less)", test_num);
            alufn = 6'b000110;
            a = 16'h0001;
            b = 16'h0002;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LE - True (Equal)", test_num);
            alufn = 6'b000110;
            a = 16'h8000;
            b = 16'h8000;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LE - False", test_num);
            alufn = 6'b000110;
            a = 16'h000A;
            b = 16'h0005;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality - Zeroes", test_num);
            alufn = 6'b000010;
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LE - Max boundary", test_num);
            alufn = 6'b000110;
            a = 16'hFFFE;
            b = 16'hFFFF;
            #1;

            check_outputs(16'h0001);
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
        input [15:0] expected_com_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_com_out === (expected_com_out ^ com_out ^ expected_com_out)) begin
                $display("PASS");
                $display("  Outputs: com_out=%h",
                         com_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: com_out=%h",
                         expected_com_out);
                $display("  Got:      com_out=%h",
                         com_out);
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
