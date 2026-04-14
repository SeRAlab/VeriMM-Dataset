`timescale 1ns/1ps

module five_bit_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] input_signal;
    reg reset;
    wire [4:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    five_bit_module dut (
        .clk(clk),
        .input_signal(input_signal),
        .reset(reset),
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
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0", test_num);
            reset_dut();
            input_signal = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 2 (Even)", test_num);
            reset_dut();
            input_signal = 5'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 1 (Odd)", test_num);
            reset_dut();
            input_signal = 5'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 30 (Even)", test_num);
            reset_dut();
            input_signal = 5'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 31 (Odd)", test_num);
            reset_dut();
            input_signal = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 16 (Even)", test_num);
            reset_dut();
            input_signal = 5'd16;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd17);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15 (Odd)", test_num);
            reset_dut();
            input_signal = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd14);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("five_bit_module Testbench");
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
        input [4:0] expected_output_signal;
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
        $dumpvars(0,clk, input_signal, reset, output_signal);
    end

endmodule
