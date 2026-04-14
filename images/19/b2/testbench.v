`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] compression_ratio;
    reg [15:0] input_signal;
    reg [15:0] threshold;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .clk(clk),
        .compression_ratio(compression_ratio),
        .input_signal(input_signal),
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
            @(posedge clk);
            compression_ratio <= 4'd1;
            input_signal <= 16'd0;
            threshold <= 16'd0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Signal below threshold", test_num);
            reset_dut();
            threshold = 16'd5000;
            compression_ratio = 4'd2;
            input_signal = 16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Signal exactly at threshold", test_num);
            reset_dut();
            threshold = 16'd5000;
            compression_ratio = 4'd4;
            input_signal = 16'd5000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Signal above threshold (Ratio 2)", test_num);
            reset_dut();
            threshold = 16'd5000;
            compression_ratio = 4'd2;
            input_signal = 16'd10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd7500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Signal above threshold (Ratio 4)", test_num);
            reset_dut();
            threshold = 16'd4000;
            compression_ratio = 4'd4;
            input_signal = 16'd12000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd6000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Ratio of 1", test_num);
            reset_dut();
            threshold = 16'd2000;
            compression_ratio = 4'd1;
            input_signal = 16'd10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High compression ratio (15)", test_num);
            reset_dut();
            threshold = 16'd1000;
            compression_ratio = 4'd15;
            input_signal = 16'd16000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd2000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero threshold", test_num);
            reset_dut();
            threshold = 16'd0;
            compression_ratio = 4'd8;
            input_signal = 16'd8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rounding check (Integer division)", test_num);
            reset_dut();
            threshold = 16'd100;
            compression_ratio = 4'd3;
            input_signal = 16'd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd233);
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
        testcase008();
        
        
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
        $dumpvars(0,clk, compression_ratio, input_signal, threshold, output_signal);
    end

endmodule
