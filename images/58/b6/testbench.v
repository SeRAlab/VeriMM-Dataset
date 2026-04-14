`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg [3:0] P;
    reg Reset;
    reg S0;
    reg S1;
    wire [3:0] Q;
    wire TerminalCount;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .P(P),
        .Reset(Reset),
        .S0(S0),
        .S1(S1),
        .Q(Q),
        .TerminalCount(TerminalCount)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            Reset = 1;
            P = 4'b0000;
            S1 = 0;
            S0 = 0;
            @(posedge CLOCK);
            #1;
            Reset = 0;
            @(posedge CLOCK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load P=4'h5");
            reset_dut();
            S1 = 1; S0 = 1; P = 4'h5;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Hold value after Reset");
            reset_dut();
            S1 = 0; S0 = 0;
            repeat(3) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Count up from 0 to 4");
            reset_dut();
            S1 = 0; S0 = 1;
            repeat(4) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h4, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Count up to terminal count 9");
            reset_dut();
            S1 = 0; S0 = 1;
            repeat(9) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h9, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Count up past terminal count (to 10)");
            reset_dut();
            S1 = 0; S0 = 1;
            repeat(10) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Load 6 then Count Down to 3");
            reset_dut();
            S1 = 1; S0 = 1; P = 4'h6;
            @(posedge CLOCK);
            #1;
            S1 = 1; S0 = 0;
            repeat(3) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h3, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load 2 then Count Down to 0 (Terminal Count)");
            reset_dut();
            S1 = 1; S0 = 1; P = 4'h2;
            @(posedge CLOCK);
            #1;
            S1 = 1; S0 = 0;
            repeat(2) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Count down past 0 to 15 (F)");
            reset_dut();
            S1 = 1; S0 = 0;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Count up to 3 then Hold");
            reset_dut();
            S1 = 0; S0 = 1;
            repeat(3) @(posedge CLOCK);
            #1;
            S1 = 0; S0 = 0;
            repeat(2) @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h3, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Count up to 5 then Down to 4");
            reset_dut();
            S1 = 0; S0 = 1;
            repeat(5) @(posedge CLOCK);
            #1;
            S1 = 1; S0 = 0;
            @(posedge CLOCK);
            #1;
            #1;

            check_outputs(4'h4, 1'b0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_TerminalCount;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_TerminalCount === (expected_TerminalCount ^ TerminalCount ^ expected_TerminalCount)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, TerminalCount=%b",
                         Q, TerminalCount);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, TerminalCount=%b",
                         expected_Q, expected_TerminalCount);
                $display("  Got:      Q=%h, TerminalCount=%b",
                         Q, TerminalCount);
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
        $dumpvars(0,CLOCK, P, Reset, S0, S1, Q, TerminalCount);
    end

endmodule
