`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] input_signal;
    reg rst;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
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
            input_signal = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            @(negedge clk) input_signal = 32'h00000000;
            @(negedge clk) input_signal = 32'h00000000;
            @(negedge clk) input_signal = 32'h00000000;
            @(negedge clk) input_signal = 32'h00000000;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Max Values", test_num);
            reset_dut();
            @(negedge clk) input_signal = 32'hFFFFFFFF;
            @(negedge clk) input_signal = 32'hFFFFFFFF;
            @(negedge clk) input_signal = 32'hFFFFFFFF;
            @(negedge clk) input_signal = 32'hFFFFFFFF;
            @(posedge clk);
            #2 #1;
 check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High Bit Scale", test_num);
            reset_dut();
            @(negedge clk) input_signal = 32'h80000000;
            @(negedge clk) input_signal = 32'h80000000;
            @(negedge clk) input_signal = 32'h80000000;
            @(negedge clk) input_signal = 32'h80000000;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Values", test_num);
            reset_dut();


            @(negedge clk) input_signal = 32'h10000000;
            @(negedge clk) input_signal = 32'h20000000;
            @(negedge clk) input_signal = 32'h30000000;
            @(negedge clk) input_signal = 32'h40000000;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h2800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Smallest MSB Bit", test_num);
            reset_dut();


            @(negedge clk) input_signal = 32'h00040000;
            @(negedge clk) input_signal = 32'h00000000;
            @(negedge clk) input_signal = 32'h00000000;
            @(negedge clk) input_signal = 32'h00000000;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Truncation Check", test_num);
            reset_dut();

            @(negedge clk) input_signal = 32'h0000FFFF;
            @(negedge clk) input_signal = 32'h0000FFFF;
            @(negedge clk) input_signal = 32'h0000FFFF;
            @(negedge clk) input_signal = 32'h0000FFFF;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Max/Min", test_num);
            reset_dut();


            @(negedge clk) input_signal = 32'hFFFFFFFF;
            @(negedge clk) input_signal = 32'h00000000;
            @(negedge clk) input_signal = 32'hFFFFFFFF;
            @(negedge clk) input_signal = 32'h00000000;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h7FFF);
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
