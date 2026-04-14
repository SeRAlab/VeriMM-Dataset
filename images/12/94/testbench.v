`timescale 1ns/1ps

module DynamicRangeCompressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] in_signal;
    reg rst;
    wire [7:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DynamicRangeCompressor dut (
        .clk(clk),
        .control(control),
        .in_signal(in_signal),
        .rst(rst),
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
            control = 0;
            in_signal = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Disabled - Input below threshold", test_num);
            reset_dut();
            control = 0;
            in_signal = 8'd75;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd75);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Disabled - Input above threshold", test_num);
            reset_dut();
            control = 0;
            in_signal = 8'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Enabled - Input below threshold", test_num);
            reset_dut();
            control = 1;
            in_signal = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Enabled - Input at threshold", test_num);
            reset_dut();
            control = 1;
            in_signal = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Enabled - Input above threshold", test_num);
            reset_dut();
            control = 1;
            in_signal = 8'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Enabled - Maximum input value", test_num);
            reset_dut();
            control = 1;
            in_signal = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Compression Enabled - Zero input", test_num);
            reset_dut();
            control = 1;
            in_signal = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check reset state", test_num);
            reset_dut();
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd0);
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
        input [7:0] expected_out_signal;
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
        $dumpvars(0,clk, control, in_signal, rst, out_signal);
    end

endmodule
