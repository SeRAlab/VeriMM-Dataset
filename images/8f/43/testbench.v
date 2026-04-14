`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg reset;
    reg start;
    reg stop;
    wire [15:0] data_out;
    wire recording;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .start(start),
        .stop(stop),
        .data_out(data_out),
        .recording(recording)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            stop = 0;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Single-Value Recording", test_num);
            reset_dut();


            start = 1;
            data = 16'hAAAA;
            @(posedge clk);
            start = 0;


            @(posedge clk);


            stop = 1;
            @(posedge clk);


            stop = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hAAAA, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture Last Recorded Data", test_num);
            reset_dut();


            start = 1;
            data = 16'h1111;
            @(posedge clk);
            start = 0;


            data = 16'h2222;
            @(posedge clk);
            data = 16'h3333;
            @(posedge clk);


            stop = 1;
            @(posedge clk);


            stop = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h3333, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Recording Signal", test_num);
            reset_dut();


            start = 1;
            data = 16'hBEEF;
            @(posedge clk);
            start = 0;


            #1;
            if (recording === 1) begin
                $display("PASS: Recording signal active");
            end else begin
                $display("FAIL: Recording signal inactive during RECORDING state");
            end


            @(posedge clk);
            stop = 1;
            @(posedge clk);
            stop = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBEEF, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Recording Cycles", test_num);
            reset_dut();


            start = 1; data = 16'h1234; @(posedge clk);
            start = 0; @(posedge clk);
            stop = 1; @(posedge clk);
            stop = 0; @(posedge clk);


            start = 1; data = 16'h5678; @(posedge clk);
            start = 0; @(posedge clk);
            stop = 1; @(posedge clk);
            stop = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5678, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extended Outputting State", test_num);
            reset_dut();

            start = 1; data = 16'hCAFE; @(posedge clk);
            start = 0; @(posedge clk);


            stop = 1;
            repeat(3) @(posedge clk);


            if (recording !== 0) $display("FAIL: recording should be 0 in OUTPUTTING state");

            stop = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hCAFE, 0);
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
        input [15:0] expected_data_out;
        input expected_recording;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_recording === (expected_recording ^ recording ^ expected_recording)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, recording=%b",
                         data_out, recording);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, recording=%b",
                         expected_data_out, expected_recording);
                $display("  Got:      data_out=%h, recording=%b",
                         data_out, recording);
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
        $dumpvars(0,clk, data, reset, start, stop, data_out, recording);
    end

endmodule
