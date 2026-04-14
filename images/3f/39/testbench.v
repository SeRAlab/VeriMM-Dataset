`timescale 1ns/1ps

module echo_canceller_tb;

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
    echo_canceller dut (
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
            signal_in = 0;
            echo_ref = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Cancellation (0x1000 - 0x0100)", test_num);
            reset_dut();
            signal_in = 16'h1000;
            echo_ref = 16'h0100;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Zero Echo Ref (0xFFFF - 0x0000)", test_num);
            reset_dut();
            signal_in = 16'hFFFF;
            echo_ref = 16'h0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Full Cancellation (0x1234 - 0x1234)", test_num);
            reset_dut();
            signal_in = 16'h1234;
            echo_ref = 16'h1234;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Wrap-around/Negative (0x0010 - 0x0020)", test_num);
            reset_dut();
            signal_in = 16'h0010;
            echo_ref = 16'h0020;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Max Values (0xAAAA - 0x5555)", test_num);
            reset_dut();
            signal_in = 16'hAAAA;
            echo_ref = 16'h5555;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_canceller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
