`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_signal;
    reg rst;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
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
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Subtraction", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 8'd10;
            @(posedge clk);
            input_signal <= 8'd25;
            #2;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Steady State Input", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 8'd50;
            @(posedge clk);
            input_signal <= 8'd50;
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Negative Result Wrap-around", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 8'd20;
            @(posedge clk);
            input_signal <= 8'd10;
            #2;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Max Range Transition", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 8'd0;
            @(posedge clk);
            input_signal <= 8'd255;
            #2;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Underflow from zero", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 8'd255;
            @(posedge clk);
            input_signal <= 8'd0;
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple step verification", test_num);
            reset_dut();
            @(posedge clk);
            input_signal <= 8'd100;
            @(posedge clk);
            input_signal <= 8'd150;
            @(posedge clk);
            input_signal <= 8'd200;
            #2;
            #1;

            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        input [7:0] expected_output_signal;
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
