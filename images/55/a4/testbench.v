`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    wire out_comb_ff;
    wire [1:0] out_counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .out_comb_ff(out_comb_ff),
        .out_counter(out_counter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;

            #15;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #2;

            $display("Running Testcase %03d...", test_num);
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(4) @(posedge clk);
            #2;

            $display("Running Testcase %03d...", test_num);
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            a = 1;
            #5;

            a = 0;
            #5;
            $display("Running Testcase %03d...", test_num);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            a = 1; #5; a = 0; #5;
            a = 1; #5; a = 0; #5;
            $display("Running Testcase %03d...", test_num);
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(2) @(posedge clk);

            a = 1; #5; a = 0; #5;
            #2;
            $display("Running Testcase %03d...", test_num);

            #1;


            check_outputs(1'b1, 2'b10);
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
        input expected_out_comb_ff;
        input [1:0] expected_out_counter;
        begin
            if (expected_out_comb_ff === (expected_out_comb_ff ^ out_comb_ff ^ expected_out_comb_ff) &&
                expected_out_counter === (expected_out_counter ^ out_counter ^ expected_out_counter)) begin
                $display("PASS");
                $display("  Outputs: out_comb_ff=%b, out_counter=%h",
                         out_comb_ff, out_counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_comb_ff=%b, out_counter=%h",
                         expected_out_comb_ff, expected_out_counter);
                $display("  Got:      out_comb_ff=%b, out_counter=%h",
                         out_comb_ff, out_counter);
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
        $dumpvars(0,a, clk, out_comb_ff, out_counter);
    end

endmodule
