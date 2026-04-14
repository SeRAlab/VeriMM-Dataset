`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] mic_in;
    reg [15:0] spkr_in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mic_in(mic_in),
        .spkr_in(spkr_in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            mic_in = 16'd0;
            spkr_in = 16'd0;
            @(posedge clk);
            @(posedge clk);


        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: All zero inputs", test_num);
            mic_in = 16'h0000;
            spkr_in = 16'h0000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Mic signal, No speaker signal", test_num);
            mic_in = 16'h1234;
            spkr_in = 16'h0000;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Echo convergence (mic_in == spkr_in)", test_num);

            mic_in = 16'h0500;
            spkr_in = 16'h0500;

            repeat (500) @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Signed signal handling (No echo)", test_num);
            mic_in = -16'd5000;
            spkr_in = 16'h0000;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'hEC78);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Full scale signal", test_num);
            mic_in = 16'h7FFF;
            spkr_in = 16'h0000;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(16'h7FFF);

            mic_in = 16'h8001;
            repeat (2) @(posedge clk);
            #1;

            check_outputs(16'h8001);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, mic_in, spkr_in, out);
    end

endmodule
