`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_signal;
    reg rst;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .clk(clk),
        .input_signal(input_signal),
        .rst(rst),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_signal = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero Input signal", test_num);
            reset_dut();
            input_signal = 16'sd0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive below threshold", test_num);
            reset_dut();
            input_signal = 16'sd4000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd4000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Positive at threshold", test_num);
            reset_dut();
            input_signal = 16'sd8000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd8000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Positive above threshold (12000 -> 10000)", test_num);
            reset_dut();
            input_signal = 16'sd12000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd10000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large positive input (28000 -> 18000)", test_num);
            reset_dut();
            input_signal = 16'sd28000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd18000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Negative below threshold", test_num);
            reset_dut();
            input_signal = -16'sd4000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd4000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Negative at threshold", test_num);
            reset_dut();
            input_signal = -16'sd8000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd8000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Negative above threshold (-12000 -> -10000)", test_num);
            reset_dut();
            input_signal = -16'sd12000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd10000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Large negative input (-30000 -> -19000)", test_num);
            reset_dut();
            input_signal = -16'sd30000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd19000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Reset behavior", test_num);
            rst = 1;
            input_signal = 16'sd5000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
            rst = 0;
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
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,clk, input_signal, rst, output_signal);
    end

endmodule
