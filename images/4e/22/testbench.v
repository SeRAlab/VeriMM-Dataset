`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] bypass;
    reg clk;
    reg data_in;
    reg [2:0] delay;
    reg [1:0] mode;
    reg rst;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bypass(bypass),
        .clk(clk),
        .data_in(data_in),
        .delay(delay),
        .mode(mode),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            delay = 0;
            bypass = 0;
            mode = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Testcase 001: Reset State Check");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Bypass Mode (mode=1)");
            mode = 2'b01;
            data_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Delay Mode (mode=0, delay=1)");
            mode = 2'b00;
            delay = 3'd1;
            data_in = 1;
            @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Delay Mode (mode=0, delay=3)");
            mode = 2'b00;
            delay = 3'd3;
            data_in = 1;
            @(posedge clk);
            data_in = 0;
            for(i = 0; i < 3; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Maximum Delay (mode=0, delay=7)");
            mode = 2'b00;
            delay = 3'd7;
            data_in = 1;
            @(posedge clk);
            data_in = 0;
            for(i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase 006: Mixed Mode (mode=2, bypass=1 active)");
            mode = 2'b10;
            bypass = 2'b01;
            data_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();
            $display("Testcase 007: Mixed Mode (mode=2, bypass=0 inactive, delay=2)");
            mode = 2'b10;
            bypass = 2'b00;
            delay = 3'd2;
            data_in = 1;
            @(posedge clk);
            data_in = 0;
            for(i = 0; i < 2; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1);
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,bypass, clk, data_in, delay, mode, rst, data_out);
    end

endmodule
