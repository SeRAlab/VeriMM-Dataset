`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg low_clk;
    reg [19:0] note_div;
    reg rst_n;
    wire [15:0] audio_left;
    wire [15:0] audio_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .low_clk(low_clk),
        .note_div(note_div),
        .rst_n(rst_n),
        .audio_left(audio_left),
        .audio_right(audio_right)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            note_div = 20'd0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing small note_div=4 (5-cycle toggle)", test_num);
            reset_dut();

            note_div = 20'd4;

            repeat(5) @(posedge clk);
            #2;




            #1;





            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing medium note_div=9 (10-cycle toggle)", test_num);
            reset_dut();

            note_div = 20'd9;


            repeat(20) @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing reset impact during operation", test_num);
            reset_dut();

            note_div = 20'd20;
            repeat(10) @(posedge clk);

            rst_n = 0;
            repeat(2) @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing note_div=1 (2-cycle toggle)", test_num);
            reset_dut();

            note_div = 20'd1;




            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFF, 16'h0000);
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
        input [15:0] expected_audio_left;
        input [15:0] expected_audio_right;
        begin
            if (expected_audio_left === (expected_audio_left ^ audio_left ^ expected_audio_left) &&
                expected_audio_right === (expected_audio_right ^ audio_right ^ expected_audio_right)) begin
                $display("PASS");
                $display("  Outputs: audio_left=%h, audio_right=%h",
                         audio_left, audio_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_left=%h, audio_right=%h",
                         expected_audio_left, expected_audio_right);
                $display("  Got:      audio_left=%h, audio_right=%h",
                         audio_left, audio_right);
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
        $dumpvars(0,clk, low_clk, note_div, rst_n, audio_left, audio_right);
    end

endmodule
