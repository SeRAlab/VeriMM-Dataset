`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg SELECT;
    reg UP_DOWN;
    reg [3:0] in;
    wire [3:0] Q;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .SELECT(SELECT),
        .UP_DOWN(UP_DOWN),
        .in(in),
        .Q(Q),
        .parity(parity)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            UP_DOWN = 0;
            SELECT = 0;
            in = 4'b0000;
            @(posedge CLK);
            #1;
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            SELECT = 1;
            #2;
            $display("Testcase 001: Reset Check");
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            UP_DOWN = 1;
            SELECT = 1;
            repeat(2) @(posedge CLK);
            #2;
            $display("Testcase 002: Increment twice, SELECT=1");
            #1;

            check_outputs(4'h2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            UP_DOWN = 1;
            SELECT = 1;
            repeat(3) @(posedge CLK);
            #2;
            $display("Testcase 003: Increment 3 times, SELECT=1");
            #1;

            check_outputs(4'h3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            UP_DOWN = 1;
            SELECT = 0;
            repeat(3) @(posedge CLK);
            #2;
            $display("Testcase 004: Increment 3 times, SELECT=0");
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            UP_DOWN = 1;
            SELECT = 0;
            repeat(4) @(posedge CLK);
            #2;
            $display("Testcase 005: Increment 4 times, SELECT=0");
            #1;

            check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            UP_DOWN = 0;
            SELECT = 1;
            repeat(1) @(posedge CLK);
            #2;
            $display("Testcase 006: Underflow Decrement, SELECT=1");
            #1;

            check_outputs(4'hf, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            SELECT = 1;
            UP_DOWN = 1;
            repeat(7) @(posedge CLK);
            UP_DOWN = 0;
            repeat(1) @(posedge CLK);
            #2;
            $display("Testcase 007: Up 7 then Down 1, SELECT=1");
            #1;

            check_outputs(4'h6, 1'b0);
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
        input [3:0] expected_Q;
        input expected_parity;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, parity=%b",
                         Q, parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, parity=%b",
                         expected_Q, expected_parity);
                $display("  Got:      Q=%h, parity=%b",
                         Q, parity);
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
        $dumpvars(0,CLK, RESET, SELECT, UP_DOWN, in, Q, parity);
    end

endmodule
