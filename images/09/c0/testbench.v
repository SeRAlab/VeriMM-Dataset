`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] delayed_signal;
    reg reset;
    reg [15:0] signal_in;
    wire [15:0] echo_cancelled_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .delayed_signal(delayed_signal),
        .reset(reset),
        .signal_in(signal_in),
        .echo_cancelled_out(echo_cancelled_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        signal_in = 0;
        delayed_signal = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Subtraction (1000 - 200)", test_num);
        reset_dut();
        signal_in = 16'd1000;
        delayed_signal = 16'd200;
        @(posedge clk);
        #1 #1;
 check_outputs(16'd800);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Perfect Cancellation (Signal == Echo)", test_num);
        reset_dut();
        signal_in = 16'hABCD;
        delayed_signal = 16'hABCD;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Underflow / Negative Result (100 - 500)", test_num);
        reset_dut();
        signal_in = 16'd100;
        delayed_signal = 16'd500;
        @(posedge clk);
        #1 #1;
 check_outputs(16'hFF6C);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No Echo (Delayed signal = 0)", test_num);
        reset_dut();
        signal_in = 16'h1234;
        delayed_signal = 16'h0000;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full-scale Values (0xFFFF - 0x0001)", test_num);
        reset_dut();
        signal_in = 16'hFFFF;
        delayed_signal = 16'h0001;
        @(posedge clk);
        #1 #1;
 check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority Check", test_num);
        reset_dut();
        signal_in = 16'h5555;
        delayed_signal = 16'h1111;
        reset = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
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
        input [15:0] expected_echo_cancelled_out;
        begin
            if (expected_echo_cancelled_out === (expected_echo_cancelled_out ^ echo_cancelled_out ^ expected_echo_cancelled_out)) begin
                $display("PASS");
                $display("  Outputs: echo_cancelled_out=%h",
                         echo_cancelled_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: echo_cancelled_out=%h",
                         expected_echo_cancelled_out);
                $display("  Got:      echo_cancelled_out=%h",
                         echo_cancelled_out);
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
        $dumpvars(0,clk, delayed_signal, reset, signal_in, echo_cancelled_out);
    end

endmodule
