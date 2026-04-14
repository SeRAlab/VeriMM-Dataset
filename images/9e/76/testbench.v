`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    reg [3:0] time_window;
    wire fall;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .time_window(time_window),
        .fall(fall),
        .rise(rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            time_window = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Rising Edge Detection");
            reset_dut();
            time_window = 4'd0;
            data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Falling Edge Detection");
            reset_dut();
            data = 1;
            @(posedge clk);
            time_window = 4'd0;
            data = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Edge ignored within time window");
            reset_dut();
            time_window = 4'd5;
            data = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            data = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Edge detected after window expires");
            reset_dut();
            time_window = 4'd3;
            data = 1;
            @(posedge clk);

            repeat(4) @(posedge clk);
            data = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Zero window back-to-back detection");
            reset_dut();
            time_window = 4'd0;
            data = 1;
            @(posedge clk);
            data = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Reset clears lockout timer");
            reset_dut();
            time_window = 4'd10;
            data = 1;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            data = 0;
            @(posedge clk);

            data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Maximum window size (15)");
            reset_dut();
            time_window = 4'hF;
            data = 1;
            @(posedge clk);


            repeat(14) @(posedge clk);
            data = 0;
            @(posedge clk);
            #1;
            if (fall == 0) begin
                $display("Pass: Edge ignored at count 14/15");
                pass_count = pass_count + 1;
            end else begin
                $display("Fail: Edge triggered too early");
                fail_count = fail_count + 1;
            end


            repeat(2) @(posedge clk);
            data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
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
        input expected_fall;
        input expected_rise;
        begin
            if (expected_fall === (expected_fall ^ fall ^ expected_fall) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: fall=%b, rise=%b",
                         fall, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall=%b, rise=%b",
                         expected_fall, expected_rise);
                $display("  Got:      fall=%b, rise=%b",
                         fall, rise);
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
        $dumpvars(0,clk, data, reset, time_window, fall, rise);
    end

endmodule
