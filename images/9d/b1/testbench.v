`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_100MHz;
    reg [17:0] cnt_val;
    reg rst;
    reg [1:0] state;
    wire music;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_100MHz(clk_100MHz),
        .cnt_val(cnt_val),
        .rst(rst),
        .state(state),
        .music(music)
    );

    // Clock generation (10ns period)
    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz;
    end

        task reset_dut;

        begin
            rst = 1;
            state = STOP;
            cnt_val = 18'd0;
            repeat(2) @(posedge clk_100MHz);
            #1;
            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset behavior check");
            reset_dut();

            rst = 1;
            #20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: STOP state behavior check");
            reset_dut();
            state = STOP;
            cnt_val = 18'd6000;
            repeat(20) @(posedge clk_100MHz);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Zero cnt_val behavior check");
            reset_dut();
            state = PLAY;
            cnt_val = 18'd0;
            repeat(20) @(posedge clk_100MHz);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Toggle verification (First inversion)");
            reset_dut();
            state = PLAY;
            cnt_val = 18'd5005;


            repeat(5) @(posedge clk_100MHz);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Double toggle verification");
            reset_dut();
            state = PLAY;
            cnt_val = 18'd5002;



            repeat(4) @(posedge clk_100MHz);
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
        input expected_music;
        begin
            if (expected_music === (expected_music ^ music ^ expected_music)) begin
                $display("PASS");
                $display("  Outputs: music=%b",
                         music);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: music=%b",
                         expected_music);
                $display("  Got:      music=%b",
                         music);
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
        $dumpvars(0,clk_100MHz, cnt_val, rst, state, music);
    end

endmodule
