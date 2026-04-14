`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg [15:0] in_word;
    wire flag;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .in_word(in_word),
        .flag(flag),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .pos(pos)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input is all zero (in=0, in_word=0x1020)", test_num);
            in = 4'b0000;
            in_word = 16'h1020;

            #1;


            check_outputs(1'b1, 8'h30, 8'h30, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Highest bit at pos 3 (in=1000, in_word=0xAABB)", test_num);
            in = 4'b1000;
            in_word = 16'hAABB;

            #1;


            check_outputs(1'b0, 8'hAA, 8'h00, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Highest bit at pos 2 (in=0100, in_word=0xAABB)", test_num);
            in = 4'b0100;
            in_word = 16'hAABB;

            #1;


            check_outputs(1'b0, 8'h00, 8'hAA, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Highest bit at pos 1 (in=0010, in_word=0xAABB)", test_num);
            in = 4'b0010;
            in_word = 16'hAABB;

            #1;


            check_outputs(1'b0, 8'hBB, 8'h00, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Highest bit at pos 0 (in=0001, in_word=0xAABB)", test_num);
            in = 4'b0001;
            in_word = 16'hAABB;

            #1;


            check_outputs(1'b0, 8'h00, 8'hBB, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check - Multiple bits set (in=1011, in_word=0x1234)", test_num);
            in = 4'b1011;
            in_word = 16'h1234;

            #1;


            check_outputs(1'b0, 8'h12, 8'h00, 2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check - bits 1 and 0 (in=0011, in_word=0xCCDD)", test_num);
            in = 4'b0011;
            in_word = 16'hCCDD;

            #1;


            check_outputs(1'b0, 8'hDD, 8'h00, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input with overflow summation (in=0000, in_word=0xFF01)", test_num);
            in = 4'b0000;
            in_word = 16'hFF01;

            #1;


            check_outputs(1'b1, 8'h00, 8'h00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition - bits 2 and 0 (in=0101, in_word=0x5566)", test_num);
            in = 4'b0101;
            in_word = 16'h5566;

            #1;


            check_outputs(1'b0, 8'h00, 8'h55, 2'b10);
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
        input expected_flag;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [1:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag === (expected_flag ^ flag ^ expected_flag) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: flag=%b, out_hi=%h, out_lo=%h, pos=%h",
                         flag, out_hi, out_lo, pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b, out_hi=%h, out_lo=%h, pos=%h",
                         expected_flag, expected_out_hi, expected_out_lo, expected_pos);
                $display("  Got:      flag=%b, out_hi=%h, out_lo=%h, pos=%h",
                         flag, out_hi, out_lo, pos);
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
