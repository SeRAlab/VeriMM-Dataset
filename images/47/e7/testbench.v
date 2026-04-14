`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_in;
    reg [15:0] signal_in;
    wire [3:0] waveform_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control_in(control_in),
        .signal_in(signal_in),
        .waveform_out(waveform_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal_in = 16'h0;
            control_in = 4'h0;


            repeat (16) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Quartet 0 (signal_in[3:0])", test_num);
            reset_dut();
            signal_in = 16'h1234;
            control_in = 4'd0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Quartet 1 (signal_in[7:4])", test_num);
            reset_dut();
            signal_in = 16'hABCD;
            control_in = 4'd1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Quartet 2 (signal_in[11:8])", test_num);
            reset_dut();
            signal_in = 16'hABCD;
            control_in = 4'd2;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Quartet 3 (signal_in[15:12])", test_num);
            reset_dut();
            signal_in = 16'hABCD;
            control_in = 4'd3;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify 'Most Recent' Capture", test_num);
            reset_dut();
            control_in = 4'd0;
            signal_in = 16'h0000;


            repeat(7) @(posedge clk);
            signal_in = 16'h000F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Control Line change mid-cycle", test_num);
            reset_dut();
            signal_in = 16'h1234;
            control_in = 4'd0;

            repeat(7) @(posedge clk);
            control_in = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3);
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
        input [3:0] expected_waveform_out;
        begin
            if (expected_waveform_out === (expected_waveform_out ^ waveform_out ^ expected_waveform_out)) begin
                $display("PASS");
                $display("  Outputs: waveform_out=%h",
                         waveform_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: waveform_out=%h",
                         expected_waveform_out);
                $display("  Got:      waveform_out=%h",
                         waveform_out);
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
        $dumpvars(0,clk, control_in, signal_in, waveform_out);
    end

endmodule
