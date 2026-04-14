`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] echo_ref;
    reg reset;
    reg [15:0] signal_in;
    wire [15:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .echo_ref(echo_ref),
        .reset(reset),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            echo_ref = 0;
            signal_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Zero Inputs");
            reset_dut();
            signal_in = 16'h0000;
            echo_ref = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Clean Signal (No Echo)");
            reset_dut();
            signal_in = 16'hA5A5;
            echo_ref = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Pure Echo (Full Cancellation)");
            reset_dut();
            signal_in = 16'h1234;
            echo_ref = 16'h1234;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Standard Subtraction");
            reset_dut();
            signal_in = 16'h5000;
            echo_ref = 16'h1000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Underflow (Negative Result)");
            reset_dut();
            signal_in = 16'h0005;
            echo_ref = 16'h000A;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFB);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Maximum Values");
            reset_dut();
            signal_in = 16'hFFFF;
            echo_ref = 16'h0001;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFE);
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
        input [15:0] expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
        $dumpvars(0,clk, echo_ref, reset, signal_in, signal_out);
    end

endmodule
