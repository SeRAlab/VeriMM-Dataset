`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [7:0] i_duration;
    reg i_reset;
    reg i_start;
    wire o_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_duration(i_duration),
        .i_reset(i_reset),
        .i_start(i_start),
        .o_pulse(o_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_reset = 1;
            i_start = 0;
            i_duration = 0;
            @(negedge i_clk);
            i_reset = 0;
            @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Pulse completion after duration 5", test_num);
            reset_dut();
            i_duration = 8'd5;
            @(negedge i_clk);
            i_start = 1;
            @(negedge i_clk);
            i_start = 0;

            repeat(6) @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Pulse active during countdown", test_num);
            reset_dut();
            i_duration = 8'd10;
            @(negedge i_clk);
            i_start = 1;
            @(negedge i_clk);
            i_start = 0;

            repeat(4) @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Asynchronous reset during active pulse", test_num);
            reset_dut();
            i_duration = 8'd20;
            @(negedge i_clk);
            i_start = 1;
            @(negedge i_clk);
            i_start = 0;
            repeat(5) @(posedge i_clk);

            #3 i_reset = 1;
            #2;
            #1;

            check_outputs(1'b0);
            #5 i_reset = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Zero duration pulse", test_num);
            reset_dut();
            i_duration = 8'd0;
            @(negedge i_clk);
            i_start = 1;
            @(negedge i_clk);
            i_start = 0;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Consecutive pulses", test_num);
            reset_dut();

            i_duration = 8'd2;
            @(negedge i_clk);
            i_start = 1;
            @(negedge i_clk);
            i_start = 0;
            repeat(3) @(posedge i_clk);


            i_duration = 8'd3;
            @(negedge i_clk);
            i_start = 1;
            @(negedge i_clk);
            i_start = 0;
            repeat(4) @(posedge i_clk);
            #1;
            #1;

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
        input expected_o_pulse;
        begin
            if (expected_o_pulse === (expected_o_pulse ^ o_pulse ^ expected_o_pulse)) begin
                $display("PASS");
                $display("  Outputs: o_pulse=%b",
                         o_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_pulse=%b",
                         expected_o_pulse);
                $display("  Got:      o_pulse=%b",
                         o_pulse);
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
        $dumpvars(0,i_clk, i_duration, i_reset, i_start, o_pulse);
    end

endmodule
