`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] echo_signal;
    reg [15:0] input_signal;
    reg rst;
    wire [15:0] canceled_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .echo_signal(echo_signal),
        .input_signal(input_signal),
        .rst(rst),
        .canceled_signal(canceled_signal)
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
            echo_signal = 0;
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
            reset_dut();
            $display("Test Case %0d: Basic Subtraction", test_num);
            input_signal = 16'h1000;
            echo_signal  = 16'h0200;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0E00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Complete Cancellation", test_num);
            input_signal = 16'hABCD;
            echo_signal  = 16'hABCD;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Zero Echo Signal", test_num);
            input_signal = 16'h7FFF;
            echo_signal  = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Underflow Handling", test_num);
            input_signal = 16'h0005;
            echo_signal  = 16'h000A;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Maximum Value Subtraction", test_num);
            input_signal = 16'hFFFF;
            echo_signal  = 16'h0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Small Signal Processing", test_num);
            input_signal = 16'h0002;
            echo_signal  = 16'h0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0001);
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
        input [15:0] expected_canceled_signal;
        begin
            if (expected_canceled_signal === (expected_canceled_signal ^ canceled_signal ^ expected_canceled_signal)) begin
                $display("PASS");
                $display("  Outputs: canceled_signal=%h",
                         canceled_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: canceled_signal=%h",
                         expected_canceled_signal);
                $display("  Got:      canceled_signal=%h",
                         canceled_signal);
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
        $dumpvars(0,clk, echo_signal, input_signal, rst, canceled_signal);
    end

endmodule
