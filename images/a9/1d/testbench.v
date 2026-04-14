`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [7:0] final_output;
    wire out_and;
    wire out_or;
    wire out_xor;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .final_output(final_output),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .pos(pos)
    );
    task verify_logic;

        input [3:0] val;
        reg e_and, e_or, e_xor;
        reg [1:0] e_pos;
        reg [7:0] e_final;
        begin
            in = val;


            e_and = &val;
            e_or  = |val;
            e_xor = ^val;


            if (val[3])      e_pos = 2'd3;
            else if (val[2]) e_pos = 2'd2;
            else if (val[1]) e_pos = 2'd1;
            else             e_pos = 2'd0;



            e_final = {~val, val};

            #10;
            #1;

            check_outputs(e_final, e_and, e_or, e_xor, e_pos);
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Input 0000 (All Zeros)");
            verify_logic(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 1111 (All Ones)");
            verify_logic(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 0001");
            verify_logic(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input 0010");
            verify_logic(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 0100");
            verify_logic(4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input 1000");
            verify_logic(4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input 1010");
            verify_logic(4'b1010);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 0110");
            verify_logic(4'b0110);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input 1011");
            verify_logic(4'b1011);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input 0111");
            verify_logic(4'b0111);
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
        input [7:0] expected_final_output;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        input [1:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, out_and=%b, out_or=%b, out_xor=%b, pos=%h",
                         final_output, out_and, out_or, out_xor, pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, out_and=%b, out_or=%b, out_xor=%b, pos=%h",
                         expected_final_output, expected_out_and, expected_out_or, expected_out_xor, expected_pos);
                $display("  Got:      final_output=%h, out_and=%b, out_or=%b, out_xor=%b, pos=%h",
                         final_output, out_and, out_or, out_xor, pos);
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
