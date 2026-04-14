`timescale 1ns/1ps

module DynamicRangeCompressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] compression_ratio;
    reg rst;
    reg [15:0] signal_in;
    wire [15:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DynamicRangeCompressor dut (
        .clk(clk),
        .compression_ratio(compression_ratio),
        .rst(rst),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_in = 0;
            compression_ratio = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and Zero Input", test_num);
            reset_dut();

            compression_ratio = 4'd2;
            signal_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No Compression (Ratio 1)", test_num);
            reset_dut();
            compression_ratio = 4'd1;
            signal_in = 16'hAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Ratio 2", test_num);
            reset_dut();
            compression_ratio = 4'd2;
            signal_in = 16'h4000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Compression (Ratio 10)", test_num);
            reset_dut();
            compression_ratio = 4'd10;
            signal_in = 16'd5000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Input and Max Ratio (15)", test_num);
            reset_dut();
            compression_ratio = 4'd15;
            signal_in = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd4369);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Ratio 0 behavior", test_num);
            reset_dut();
            compression_ratio = 4'd0;
            signal_in = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small signal with high ratio", test_num);
            reset_dut();
            compression_ratio = 4'd8;
            signal_in = 16'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
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
        input [15:0] expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
        $dumpvars(0,clk, compression_ratio, rst, signal_in, signal_out);
    end

endmodule
