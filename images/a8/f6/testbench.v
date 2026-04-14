`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_model;
    reg rst_n;
    wire out_spike;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_model(input_model),
        .rst_n(rst_n),
        .out_spike(out_spike)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            input_model = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            input_model = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input_model = 1;
            repeat(2) @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input_model = 1;
            repeat(3) @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input_model = 1;
            @(posedge clk);
            input_model = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input_model = 1;

            repeat(10) @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            input_model = 1;
            repeat(2) @(posedge clk);
            rst_n = 0;
            #2 #1;
 check_outputs(1'b0);
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
        input expected_out_spike;
        begin
            if (expected_out_spike === (expected_out_spike ^ out_spike ^ expected_out_spike)) begin
                $display("PASS");
                $display("  Outputs: out_spike=%b",
                         out_spike);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_spike=%b",
                         expected_out_spike);
                $display("  Got:      out_spike=%b",
                         out_spike);
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
        $dumpvars(0,clk, input_model, rst_n, out_spike);
    end

endmodule
