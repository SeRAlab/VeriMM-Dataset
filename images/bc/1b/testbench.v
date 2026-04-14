`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] BeginCount;
    reg CLOCK;
    reg [7:0] EndCount;
    reg [7:0] P;
    reg Reset;
    reg S0;
    reg S1;
    wire [7:0] Q;
    wire TerminalCount;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BeginCount(BeginCount),
        .CLOCK(CLOCK),
        .EndCount(EndCount),
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
            S1 = 0;
            S0 = 0;
            P = 8'h00;
            BeginCount = 8'h00;
            EndCount = 8'hFF;
            #12;
            Reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset Check", test_num);
            Reset = 1;
            BeginCount = 8'h5A;
            EndCount = 8'hFF;
            #10;
            Reset = 0;
            #5;

            #1;


            check_outputs(8'h5A, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load (Mode 11)", test_num);
            reset_dut();
            S1 = 1; S0 = 1;
            P = 8'hA5;
            @(posedge CLOCK);
            #2;
            #1;

            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Value (Mode 00)", test_num);
            reset_dut();

            S1 = 1; S0 = 1; P = 8'h22;
            @(posedge CLOCK);
            #2;

            S1 = 0; S0 = 0;
            repeat(3) @(posedge CLOCK);
            #2;
            #1;

            check_outputs(8'h22, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Up to EndCount", test_num);
            reset_dut();
            BeginCount = 8'h10;
            EndCount = 8'h13;
            Reset = 1; #10; Reset = 0; #5;

            S1 = 0; S0 = 1;

            @(posedge CLOCK);

            @(posedge CLOCK);

            @(posedge CLOCK);
            #2;

            #1;


            check_outputs(8'h13, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Up Wrap Around to BeginCount", test_num);
            reset_dut();
            BeginCount = 8'h10;
            EndCount = 8'h11;
            Reset = 1; #10; Reset = 0; #5;

            S1 = 0; S0 = 1;
            @(posedge CLOCK);
            @(posedge CLOCK);
            #2;
            #1;

            check_outputs(8'h10, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Down to BeginCount", test_num);
            reset_dut();
            BeginCount = 8'hF0;
            EndCount = 8'hF2;

            S1 = 1; S0 = 1; P = 8'hF2;
            @(posedge CLOCK);
            #2;

            S1 = 1; S0 = 0;
            @(posedge CLOCK);
            @(posedge CLOCK);
            #2;
            #1;

            check_outputs(8'hF0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Down Wrap Around to EndCount", test_num);
            reset_dut();
            BeginCount = 8'h0A;
            EndCount = 8'h0C;

            S1 = 1; S0 = 1; P = 8'h0A;
            @(posedge CLOCK);

            S1 = 1; S0 = 0;
            @(posedge CLOCK);
            #2;
            #1;

            check_outputs(8'h0C, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex Sequence Mode Switching", test_num);
            reset_dut();
            BeginCount = 8'h00;
            EndCount = 8'hFF;


            S1 = 1; S0 = 1; P = 8'h80;
            @(posedge CLOCK);

            S1 = 0; S0 = 1;
            repeat(2) @(posedge CLOCK);

            S1 = 0; S0 = 0;
            repeat(2) @(posedge CLOCK);

            S1 = 1; S0 = 0;
            @(posedge CLOCK);
            #2;
            #1;

            check_outputs(8'h81, 1'b0);
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
        input [7:0] expected_Q;
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
        $dumpvars(0,BeginCount, CLOCK, EndCount, P, Reset, S0, S1, Q, TerminalCount);
    end

endmodule
