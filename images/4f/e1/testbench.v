`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] binary_in;
    wire [2:0] binary_out;
    wire bit0_out;
    wire bit1_out;
    wire bit2_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .binary_out(binary_out),
        .bit0_out(bit0_out),
        .bit1_out(bit1_out),
        .bit2_out(bit2_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Input 3'b000", test_num);
            binary_in = 3'b000;
            #1;

            check_outputs(3'b000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Input 3'b001", test_num);
            binary_in = 3'b001;
            #1;

            check_outputs(3'b001, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Input 3'b010", test_num);
            binary_in = 3'b010;
            #1;

            check_outputs(3'b010, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Input 3'b011", test_num);
            binary_in = 3'b011;
            #1;

            check_outputs(3'b011, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Input 3'b100", test_num);
            binary_in = 3'b100;
            #1;

            check_outputs(3'b100, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Input 3'b101", test_num);
            binary_in = 3'b101;
            #1;

            check_outputs(3'b101, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Input 3'b110", test_num);
            binary_in = 3'b110;
            #1;

            check_outputs(3'b110, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Input 3'b111", test_num);
            binary_in = 3'b111;
            #1;

            check_outputs(3'b111, 1'b1, 1'b1, 1'b1);
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
        input [2:0] expected_binary_out;
        input expected_bit0_out;
        input expected_bit1_out;
        input expected_bit2_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out) &&
                expected_bit0_out === (expected_bit0_out ^ bit0_out ^ expected_bit0_out) &&
                expected_bit1_out === (expected_bit1_out ^ bit1_out ^ expected_bit1_out) &&
                expected_bit2_out === (expected_bit2_out ^ bit2_out ^ expected_bit2_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h, bit0_out=%b, bit1_out=%b, bit2_out=%b",
                         binary_out, bit0_out, bit1_out, bit2_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h, bit0_out=%b, bit1_out=%b, bit2_out=%b",
                         expected_binary_out, expected_bit0_out, expected_bit1_out, expected_bit2_out);
                $display("  Got:      binary_out=%h, bit0_out=%b, bit1_out=%b, bit2_out=%b",
                         binary_out, bit0_out, bit1_out, bit2_out);
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
