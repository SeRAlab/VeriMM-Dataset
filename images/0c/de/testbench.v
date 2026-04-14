`timescale 1ns/1ps

module FractionalN_PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_signal;
    reg [15:0] input_freq;
    reg reset;
    wire [15:0] output_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FractionalN_PLL dut (
        .clk(clk),
        .control_signal(control_signal),
        .input_freq(input_freq),
        .reset(reset),
        .output_freq(output_freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clk = 0;
            control_signal = 4'b0000;
            input_freq = 16'h0000;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 1:1 Division", test_num);
            reset_dut();
            input_freq = 16'd1000;
            control_signal = 4'd0;
            #100;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fractional Division (1.5x)", test_num);
            reset_dut();
            input_freq = 16'd1500;
            control_signal = 4'd5;
            #100;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Integer Division (2.0x)", test_num);
            reset_dut();
            input_freq = 16'd2000;
            control_signal = 4'd10;
            #100;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Control Signal", test_num);
            reset_dut();
            input_freq = 16'd5000;
            control_signal = 4'd15;
            #100;
            #1;

            check_outputs(16'd2000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Frequency Input", test_num);
            reset_dut();
            input_freq = 16'd10000;
            control_signal = 4'd2;
            #100;
            #1;

            check_outputs(16'd8333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();
            input_freq = 16'd4000;
            control_signal = 4'd0;
            #40;
            reset = 1;
            #40;
            reset = 0;
            #100;


            #1;



            check_outputs(16'd4000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FractionalN_PLL Testbench");
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
        input [15:0] expected_output_freq;
        begin
            if (expected_output_freq === (expected_output_freq ^ output_freq ^ expected_output_freq)) begin
                $display("PASS");
                $display("  Outputs: output_freq=%h",
                         output_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_freq=%h",
                         expected_output_freq);
                $display("  Got:      output_freq=%h",
                         output_freq);
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
        $dumpvars(0,clk, control_signal, input_freq, reset, output_freq);
    end

endmodule
