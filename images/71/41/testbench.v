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
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs zero (4'b0000)", test_num);
            in = 4'b0000;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input LSB only (4'b0001)", test_num);
            in = 4'b0001;

            #1;


            check_outputs(8'h0C, 1'b0, 1'b1, 1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input bit 1 (4'b0010)", test_num);
            in = 4'b0010;

            #1;


            check_outputs(8'h0D, 1'b0, 1'b1, 1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input bit 2 (4'b0100)", test_num);
            in = 4'b0100;

            #1;


            check_outputs(8'h0E, 1'b0, 1'b1, 1'b1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Input bit 3 (4'b1000)", test_num);
            in = 4'b1000;

            #1;


            check_outputs(8'h0F, 1'b0, 1'b1, 1'b1, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All inputs high (4'b1111)", test_num);
            in = 4'b1111;

            #1;


            check_outputs(8'h1B, 1'b1, 1'b1, 1'b0, 2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple bits set, check priority (4'b1011)", test_num);
            in = 4'b1011;

            #1;


            check_outputs(8'h0F, 1'b0, 1'b1, 1'b1, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Middle bits set, check parity/priority (4'b0110)", test_num);
            in = 4'b0110;

            #1;


            check_outputs(8'h0A, 1'b0, 1'b1, 1'b0, 2'b10);
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
