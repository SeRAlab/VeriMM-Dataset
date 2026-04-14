`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("\nTestcase 001: No inputs active");
        test_num = 1;
        in = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Only lowest position (in[0]) active");
        test_num = 2;
        in = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Only position 1 active");
        test_num = 3;
        in = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Only position 2 active");
        test_num = 4;
        in = 4'b0100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Only highest position (in[3]) active");
        test_num = 5;
        in = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Multiple inputs - in[0] should take priority over in[1]");
        test_num = 6;
        in = 4'b0011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Multiple inputs - in[0] should take priority over all");
        test_num = 7;
        in = 4'b1111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("\nTestcase 008: Multiple inputs - in[1] should take priority over in[2] and in[3]");
        test_num = 8;
        in = 4'b1110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("\nTestcase 009: Multiple inputs - in[2] should take priority over in[3]");
        test_num = 9;
        in = 4'b1100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("\nTestcase 010: Sparse inputs - in[1] and in[3] active");
        test_num = 10;
        in = 4'b1010;
        #1;

        check_outputs(1'b1);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
