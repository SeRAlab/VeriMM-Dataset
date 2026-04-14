`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] DURATION;
    reg RST;
    reg START;
    wire PULSE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DURATION(DURATION),
        .RST(RST),
        .START(START),
        .PULSE(PULSE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            START = 0;
            DURATION = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal pulse completion (Duration 10)", test_num);
            reset_dut();
            DURATION = 16'd10;
            START = 1;

            repeat (11) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Pulse active mid-duration (Duration 10, Check at 5)", test_num);
            reset_dut();
            DURATION = 16'd10;
            START = 1;
            repeat (5) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: START signal de-asserted mid-pulse", test_num);
            reset_dut();
            DURATION = 16'd20;
            START = 1;
            repeat (5) @(posedge CLK);
            #1; START = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RST signal activated mid-pulse", test_num);
            reset_dut();
            DURATION = 16'd15;
            START = 1;
            repeat (7) @(posedge CLK);
            #1; RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Short duration (Duration 1)", test_num);
            reset_dut();
            DURATION = 16'd1;
            START = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential pulse generation", test_num);
            reset_dut();

            DURATION = 16'd3;
            START = 1;
            repeat (4) @(posedge CLK);

            DURATION = 16'd5;
            START = 1;
            repeat (3) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Large duration (Duration 100)", test_num);
            reset_dut();
            DURATION = 16'd100;
            START = 1;
            repeat (101) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_PULSE;
        begin
            if (expected_PULSE === (expected_PULSE ^ PULSE ^ expected_PULSE)) begin
                $display("PASS");
                $display("  Outputs: PULSE=%b",
                         PULSE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PULSE=%b",
                         expected_PULSE);
                $display("  Got:      PULSE=%b",
                         PULSE);
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
        $dumpvars(0,CLK, DURATION, RST, START, PULSE);
    end

endmodule
