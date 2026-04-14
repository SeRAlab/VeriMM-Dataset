`timescale 1ns/1ps

module wifi_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg disconnect;
    reg reset;
    reg start_connect;
    reg success;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_module dut (
        .clk(clk),
        .disconnect(disconnect),
        .reset(reset),
        .start_connect(start_connect),
        .success(success),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_connect = 0;
            success = 0;
            disconnect = 0;

            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Initial Reset to IDLE");
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: IDLE -> CONNECTING via start_connect");
            reset_dut();
            @(posedge clk);
            start_connect = 1;
            @(posedge clk);
            start_connect = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: CONNECTING -> CONNECTED via success");
            reset_dut();
            @(posedge clk);
            start_connect = 1;
            @(posedge clk);
            start_connect = 0;
            @(posedge clk);
            success = 1;
            @(posedge clk);
            success = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: CONNECTED -> DISCONNECTING via disconnect");
            reset_dut();

            @(posedge clk);
            start_connect = 1;
            @(posedge clk);
            start_connect = 0;
            @(posedge clk);
            success = 1;
            @(posedge clk);
            success = 0;
            @(posedge clk);

            disconnect = 1;
            @(posedge clk);
            disconnect = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: IDLE state robustness (ignore success without start)");
            reset_dut();
            @(posedge clk);
            success = 1;
            @(posedge clk);
            success = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Full Cycle (IDLE -> CONNECTING -> CONNECTED -> DISCONNECTING -> IDLE)");
            reset_dut();

            @(posedge clk);
            start_connect = 1;
            @(posedge clk);
            start_connect = 0;

            @(posedge clk);
            success = 1;
            @(posedge clk);
            success = 0;

            @(posedge clk);
            disconnect = 1;
            @(posedge clk);
            disconnect = 0;

            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_module Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, disconnect, reset, start_connect, success, state);
    end

endmodule
