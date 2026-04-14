`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_signal;
    reg [15:0] ratio;
    reg rst;
    reg [15:0] threshold;
    wire [15:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .clk(clk),
        .in_signal(in_signal),
        .ratio(ratio),
        .rst(rst),
        .threshold(threshold),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_signal = 0;
            threshold = 0;
            ratio = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            rst = 1;
            in_signal = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Signal below Threshold");
            reset_dut();
            threshold = 16'd1000;
            ratio     = 16'd2;
            in_signal = 16'd500;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Signal at Threshold");
            reset_dut();
            threshold = 16'd2000;
            ratio     = 16'd4;
            in_signal = 16'd2000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd2000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Compression Ratio 2:1");
            reset_dut();
            threshold = 16'd1000;
            ratio     = 16'd2;
            in_signal = 16'd3000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd2000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Compression Ratio 4:1");
            reset_dut();
            threshold = 16'd2000;
            ratio     = 16'd4;
            in_signal = 16'd6000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd3000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Ratio 1:1 Check");
            reset_dut();
            threshold = 16'd1000;
            ratio     = 16'd1;
            in_signal = 16'd5000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd5000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: High Input and Ratio");
            reset_dut();
            threshold = 16'd500;
            ratio     = 16'd10;
            in_signal = 16'd10500;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd1500);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [15:0] expected_out_signal;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
        $dumpvars(0,clk, in_signal, ratio, rst, threshold, out_signal);
    end

endmodule
