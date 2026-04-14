`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    wire Q0;
    wire Q1;
    wire Q2;
    wire Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin

        force dut.Q0 = 1'b1;
        force dut.Q1 = 1'b0;
        force dut.Q2 = 1'b0;
        force dut.Q3 = 1'b0;
        #10;
        release dut.Q0;
        release dut.Q1;
        release dut.Q2;
        release dut.Q3;
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 1 Cycle Shift", test_num);
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 3 Cycles Shift", test_num);
        repeat(3) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 6 Cycles Shift", test_num);
        repeat(6) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: 11 Cycles Shift", test_num);
        repeat(11) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Full Cycle (15 Shifts)", test_num);
        repeat(15) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_Q0;
        input expected_Q1;
        input expected_Q2;
        input expected_Q3;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         expected_Q0, expected_Q1, expected_Q2, expected_Q3);
                $display("  Got:      Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
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
        $dumpvars(0,CLK, Q0, Q1, Q2, Q3);
    end

endmodule
