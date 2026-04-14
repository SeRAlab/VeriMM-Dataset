`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [7:0] config_data;
    reg config_en;
    reg rst;
    wire [15:0] audio_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_in(audio_in),
        .clk(clk),
        .config_data(config_data),
        .config_en(config_en),
        .rst(rst),
        .audio_out(audio_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in = 16'h0;
            config_data = 8'h0;
            config_en = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Audio Pass-through", test_num);
            reset_dut();

            audio_in = 16'hA5A5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through with All Ones", test_num);
            reset_dut();

            audio_in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through with All Zeros", test_num);
            reset_dut();

            audio_in = 16'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Configuration Enable Check", test_num);
            reset_dut();


            config_en = 1;
            config_data = 8'hFF;
            audio_in = 16'h1234;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Cycles Pass-through", test_num);
            reset_dut();

            audio_in = 16'hCAFE;
            @(posedge clk);
            #1;
            audio_in = 16'hBABE;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hBABE, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data Pattern", test_num);
            reset_dut();

            audio_in = 16'h5AA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5AA5, 1'b1);
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
        input [15:0] expected_audio_out;
        input expected_valid_out;
        begin
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h, valid_out=%b",
                         audio_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h, valid_out=%b",
                         expected_audio_out, expected_valid_out);
                $display("  Got:      audio_out=%h, valid_out=%b",
                         audio_out, valid_out);
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
        $dumpvars(0,audio_in, clk, config_data, config_en, rst, audio_out, valid_out);
    end

endmodule
