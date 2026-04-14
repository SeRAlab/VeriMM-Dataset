`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] input_bits;
    reg reset;
    wire output_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_bits(input_bits),
        .reset(reset),
        .output_bit(output_bit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_bits = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            $display("DUT Reset to S0");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying S0 state (Initial/Reset)", test_num);
            reset_dut();
            input_bits = 2'b00;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: S0 to S1 Transition and S1 Output Check", test_num);
            reset_dut();


            input_bits = 2'b01;
            @(posedge clk);
            #2;



            input_bits = 2'b11;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: S0 to S2 Transition and S2 Output Check", test_num);
            reset_dut();


            input_bits = 2'b10;
            @(posedge clk);
            #2;



            input_bits = 2'b11;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: S1 state with non-triggering input", test_num);
            reset_dut();


            input_bits = 2'b01;
            @(posedge clk);
            #2;


            input_bits = 2'b00;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-state walk S0 -> S1 -> S2", test_num);
            reset_dut();


            input_bits = 2'b01;
            @(posedge clk);
            #2;


            input_bits = 2'b10;
            @(posedge clk);
            #2;


            input_bits = 2'b11;
            #2;
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
        input expected_output_bit;
        begin
            if (expected_output_bit === (expected_output_bit ^ output_bit ^ expected_output_bit)) begin
                $display("PASS");
                $display("  Outputs: output_bit=%b",
                         output_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_bit=%b",
                         expected_output_bit);
                $display("  Got:      output_bit=%b",
                         output_bit);
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
        $dumpvars(0,clk, input_bits, reset, output_bit);
    end

endmodule
