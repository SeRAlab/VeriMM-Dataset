`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_1;
    reg in_2;
    reg reset;
    wire out_xor_comb;
    wire out_xor_seq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_1(in_1),
        .in_2(in_2),
        .reset(reset),
        .out_xor_comb(out_xor_comb),
        .out_xor_seq(out_xor_seq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_1 = 0;
            in_2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in_1 = 0;
            in_2 = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Inputs (0,0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in_1 = 1;
            in_2 = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Inputs (1,0)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in_1 = 0;
            in_2 = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Inputs (0,1)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in_1 = 1;
            in_2 = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Inputs (1,1)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in_1 = 1; in_2 = 0;
            @(posedge clk);
            #1 in_1 = 1; in_2 = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Transition sequence 00->10->11", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            in_1 = 1; in_2 = 0;
            @(posedge clk);
            #1;

            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Verification of latching behavior", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in_1 = 1; @(posedge clk); #1;
            in_1 = 0; @(posedge clk); #1;
            in_2 = 1; @(posedge clk); #1;
            in_1 = 1; @(posedge clk); #1;
            $display("Testcase %0d: Multiple toggles", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_out_xor_comb;
        input expected_out_xor_seq;
        begin
            if (expected_out_xor_comb === (expected_out_xor_comb ^ out_xor_comb ^ expected_out_xor_comb) &&
                expected_out_xor_seq === (expected_out_xor_seq ^ out_xor_seq ^ expected_out_xor_seq)) begin
                $display("PASS");
                $display("  Outputs: out_xor_comb=%b, out_xor_seq=%b",
                         out_xor_comb, out_xor_seq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_xor_comb=%b, out_xor_seq=%b",
                         expected_out_xor_comb, expected_out_xor_seq);
                $display("  Got:      out_xor_comb=%b, out_xor_seq=%b",
                         out_xor_comb, out_xor_seq);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, in_1, in_2, reset, out_xor_comb, out_xor_seq);
    end

endmodule
