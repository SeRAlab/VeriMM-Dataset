`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RSTB;
    reg VDD;
    reg VSS;
    wire [3:0] Q;
    wire [3:0] QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RSTB(RSTB),
        .VDD(VDD),
        .VSS(VSS),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        VDD = 1;
        VSS = 0;
        RSTB = 0;
        @(posedge CLK);
        #1;
        RSTB = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Initial Reset State Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Single Increment Check", test_num);
        reset_dut();
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h1, 4'hE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Increment to 5 Check", test_num);
        reset_dut();
        repeat(5) @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h5, 4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Maximum Value Check (15 cycles)", test_num);
        reset_dut();
        repeat(15) @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Rollover Check (16 cycles)", test_num);
        reset_dut();
        repeat(16) @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Mid-point Check (8 cycles)", test_num);
        reset_dut();
        repeat(8) @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h8, 4'h7);
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
        input [3:0] expected_QN;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, QN=%h",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, QN=%h",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%h, QN=%h",
                         Q, QN);
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
        $dumpvars(0,CLK, RSTB, VDD, VSS, Q, QN);
    end

endmodule
