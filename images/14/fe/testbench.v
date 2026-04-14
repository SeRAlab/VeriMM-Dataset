`timescale 1ns/1ps

module DynamicRangeCompressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_signal;
    reg reset;
    reg [15:0] threshold;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DynamicRangeCompressor dut (
        .clk(clk),
        .input_signal(input_signal),
        .reset(reset),
        .threshold(threshold),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_signal = 0;
            threshold = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            input_signal = 16'd5000;
            threshold = 16'd10000;
            @(posedge clk);
            #1;
            $display("Test %0d: Input below threshold (Input: 5000, Thresh: 10000)", test_num);
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            input_signal = 16'd10000;
            threshold = 16'd10000;
            @(posedge clk);
            #1;
            $display("Test %0d: Input exactly at threshold (Input: 10000, Thresh: 10000)", test_num);
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            input_signal = 16'd20000;
            threshold = 16'd10000;
            @(posedge clk);
            #1;
            $display("Test %0d: Input above threshold (Input: 20000, Thresh: 10000, Ratio 2:1)", test_num);
            #1;

            check_outputs(16'd15000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            input_signal = 16'd45000;
            threshold = 16'd5000;
            @(posedge clk);
            #1;
            $display("Test %0d: High input, low threshold (Input: 45000, Thresh: 5000)", test_num);
            #1;

            check_outputs(16'd25000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            input_signal = 16'd1000;
            threshold = 16'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: Threshold at zero (Input: 1000, Thresh: 0)", test_num);
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            input_signal = 16'hFFFF;
            threshold = 16'h8000;
            @(posedge clk);
            #1;
            $display("Test %0d: Maximum input signal (Input: 65535, Thresh: 32768)", test_num);
            #1;

            check_outputs(16'd49151);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DynamicRangeCompressor Testbench");
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
        input [15:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, input_signal, reset, threshold, output_signal);
    end

endmodule
