`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [254:0] in;
    reg [31:0] in_swap;
    wire [7:0] count_out;
    wire [7:0] sum_out;
    wire [31:0] swap_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .in_swap(in_swap),
        .count_out(count_out),
        .sum_out(sum_out),
        .swap_out(swap_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            in = 255'd0;
            in_swap = 32'd0;

            #1;


            check_outputs(8'd0, 8'd0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones (Maximum Values)");
            in = {255{1'b1}};
            in_swap = 32'hFFFFFFFF;





            #1;






            check_outputs(8'hFF, 8'hFE, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple Endian Swap and Low Count");
            in = 255'h7;
            in_swap = 32'h12345678;





            #1;






            check_outputs(8'd3, 8'h7B, 32'h78563412);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating Bits and Specific Swap");

            in = {128{2'b10}};
            in_swap = 32'h00000001;





            #1;






            check_outputs(8'd127, 8'h80, 32'h01000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: High Bit Population and Addition Overflow");
            in = (255'b1 << 254) | (255'b1 << 128) | (255'b1 << 0);
            in_swap = 32'hAABBCCFF;





            #1;






            check_outputs(8'd3, 8'h02, 32'hFFCCBBAA);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Random Pattern 1");
            in = 255'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;



            in_swap = 32'hDEADC0DE;





            #1;






            check_outputs(8'd126, 8'h5C, 32'hDEC0ADDE);
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
        input [7:0] expected_count_out;
        input [7:0] expected_sum_out;
        input [31:0] expected_swap_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out) &&
                expected_swap_out === (expected_swap_out ^ swap_out ^ expected_swap_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, sum_out=%h, swap_out=%h",
                         count_out, sum_out, swap_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, sum_out=%h, swap_out=%h",
                         expected_count_out, expected_sum_out, expected_swap_out);
                $display("  Got:      count_out=%h, sum_out=%h, swap_out=%h",
                         count_out, sum_out, swap_out);
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
