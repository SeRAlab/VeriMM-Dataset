`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clock_enable;
    reg [31:0] in;
    reg reset;
    wire [3:0] counter_out;
    wire [35:0] sum_out;
    wire [31:0] transition_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clock_enable(clock_enable),
        .in(in),
        .reset(reset),
        .counter_out(counter_out),
        .sum_out(sum_out),
        .transition_out(transition_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clock_enable = 0;
            in = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000, 32'h0, 36'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            clock_enable = 1;
            in = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000, 32'h0, 36'h8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            clock_enable = 0;
            in = 32'hAAAAAAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000, 32'hAAAAAAAA, 36'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            clock_enable = 1;
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000, 32'hFFFFFFFF, 36'h100000007);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            clock_enable = 1;
            in = 32'hFFFF0000;
            @(posedge clk);
            #1;


            in = 32'h0000FFFF;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b1100, 32'hFFFFFFFF, 36'h10000000B);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            clock_enable = 1;
            @(posedge clk);
            #1;
            clock_enable = 0;
            in = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 32'h12345678, 36'h12345680);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();
            clock_enable = 1;
            in = 32'h0;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(4'b0000, 32'h0, 36'h0);
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
        input [3:0] expected_counter_out;
        input [35:0] expected_sum_out;
        input [31:0] expected_transition_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out) &&
                expected_transition_out === (expected_transition_out ^ transition_out ^ expected_transition_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, sum_out=%h, transition_out=%h",
                         counter_out, sum_out, transition_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, sum_out=%h, transition_out=%h",
                         expected_counter_out, expected_sum_out, expected_transition_out);
                $display("  Got:      counter_out=%h, sum_out=%h, transition_out=%h",
                         counter_out, sum_out, transition_out);
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
        $dumpvars(0,clk, clock_enable, in, reset, counter_out, sum_out, transition_out);
    end

endmodule
