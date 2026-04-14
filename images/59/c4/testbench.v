`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg left;
    reg reset;
    reg right;
    wire LA;
    wire LB;
    wire LC;
    wire RA;
    wire RB;
    wire RC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .left(left),
        .reset(reset),
        .right(right),
        .LA(LA),
        .LB(LB),
        .LC(LC),
        .RA(RA),
        .RB(RB),
        .RC(RC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        left = 0;
        right = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Initial Idle State");
        reset_dut();
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Left Turn - Cycle 1");
        reset_dut();
        left = 1;
        right = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Left Turn - Cycle 2");
        reset_dut();
        left = 1;
        right = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Left Turn - Cycle 3");
        reset_dut();
        left = 1;
        right = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1, 1, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Left Turn - Cycle 4 (Return to Idle)");
        reset_dut();
        left = 1;
        right = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Right Turn - Cycle 1");
        reset_dut();
        left = 0;
        right = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: Right Turn - Cycle 2");
        reset_dut();
        left = 0;
        right = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        $display("\nRunning testcase008: Right Turn - Cycle 3");
        reset_dut();
        left = 0;
        right = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 1, 1, 1);
    end
        endtask

    task testcase009;

    begin
        $display("\nRunning testcase009: Safety - Both signals active");
        reset_dut();
        left = 1;
        right = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        $display("\nRunning testcase010: Interruption - Left signal interrupted by both on");
        reset_dut();
        left = 1;
        right = 0;
        @(posedge clk);
        @(posedge clk);
        left = 1;
        right = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
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
        input expected_LA;
        input expected_LB;
        input expected_LC;
        input expected_RA;
        input expected_RB;
        input expected_RC;
        begin
            if (expected_LA === (expected_LA ^ LA ^ expected_LA) &&
                expected_LB === (expected_LB ^ LB ^ expected_LB) &&
                expected_LC === (expected_LC ^ LC ^ expected_LC) &&
                expected_RA === (expected_RA ^ RA ^ expected_RA) &&
                expected_RB === (expected_RB ^ RB ^ expected_RB) &&
                expected_RC === (expected_RC ^ RC ^ expected_RC)) begin
                $display("PASS");
                $display("  Outputs: LA=%b, LB=%b, LC=%b, RA=%b, RB=%b, RC=%b",
                         LA, LB, LC, RA, RB, RC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LA=%b, LB=%b, LC=%b, RA=%b, RB=%b, RC=%b",
                         expected_LA, expected_LB, expected_LC, expected_RA, expected_RB, expected_RC);
                $display("  Got:      LA=%b, LB=%b, LC=%b, RA=%b, RB=%b, RC=%b",
                         LA, LB, LC, RA, RB, RC);
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
        $dumpvars(0,clk, left, reset, right, LA, LB, LC, RA, RB, RC);
    end

endmodule
