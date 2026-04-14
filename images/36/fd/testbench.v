`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] echo_signal;
    reg [15:0] input_signal;
    reg rst;
    wire [15:0] cancelled_signal;

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
        .cancelled_signal(cancelled_signal)
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
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Subtraction", test_num);
        input_signal = 16'h1000;
        echo_signal  = 16'h0200;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0E00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Identical signals (Zero result)", test_num);
        input_signal = 16'hABCD;
        echo_signal  = 16'hABCD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Underflow / Wrap-around", test_num);
        input_signal = 16'h0005;
        echo_signal  = 16'h000A;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hFFFB);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Maximum input value", test_num);
        input_signal = 16'hFFFF;
        echo_signal  = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Zero input, non-zero echo", test_num);
        input_signal = 16'h0000;
        echo_signal  = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Mid-range large values", test_num);
        input_signal = 16'h8000;
        echo_signal  = 16'h7FFF;
        @(posedge clk);
        #1;
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
        input [15:0] expected_cancelled_signal;
        begin
            if (expected_cancelled_signal === (expected_cancelled_signal ^ cancelled_signal ^ expected_cancelled_signal)) begin
                $display("PASS");
                $display("  Outputs: cancelled_signal=%h",
                         cancelled_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cancelled_signal=%h",
                         expected_cancelled_signal);
                $display("  Got:      cancelled_signal=%h",
                         cancelled_signal);
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
        $dumpvars(0,clk, echo_signal, input_signal, rst, cancelled_signal);
    end

endmodule
