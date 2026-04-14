`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] compression_ratio;
    reg [15:0] input_signal;
    reg reset;
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
            compression_ratio = 1;
            threshold = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Input below positive threshold", test_num);
            threshold = 16'sd1000;
            compression_ratio = 16'd2;
            input_signal = 16'sd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd500);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Input within negative threshold range", test_num);
            threshold = 16'sd1000;
            compression_ratio = 16'd2;
            input_signal = -16'sd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd500);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Input at positive threshold", test_num);
            threshold = 16'sd2000;
            compression_ratio = 16'd4;
            input_signal = 16'sd2000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd2000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Positive excess with 2:1 ratio", test_num);
            threshold = 16'sd2000;
            compression_ratio = 16'd2;
            input_signal = 16'sd4000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd3000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Negative excess with 4:1 ratio", test_num);
            threshold = 16'sd1000;
            compression_ratio = 16'd4;
            input_signal = -16'sd5000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd2000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: High compression ratio (10:1)", test_num);
            threshold = 16'sd1000;
            compression_ratio = 16'd10;
            input_signal = 16'sd11000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd2000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Unity ratio (1:1)", test_num);
            threshold = 16'sd500;
            compression_ratio = 16'd1;
            input_signal = 16'sd5000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd5000);
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
        $dumpvars(0,clk, compression_ratio, input_signal, reset, threshold, output_signal);
    end

endmodule
