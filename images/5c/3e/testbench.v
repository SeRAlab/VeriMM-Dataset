`timescale 1ns/1ps

module top_module_tb;

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
    top_module dut (
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
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            input_signal = 5'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            input_signal = 5'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            input_signal = 5'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            input_signal = 5'd4;
            @(posedge clk);
            input_signal = 5'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            input_signal = 5'd1;
            @(posedge clk);
            input_signal = 5'd7;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            input_signal = 5'd6;
            @(posedge clk);
            input_signal = 5'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            input_signal = 5'd8;
            @(posedge clk);
            input_signal = 5'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            reset_dut();
            input_signal = 5'd2;


            for (i = 0; i < 33; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(5'd1);
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
