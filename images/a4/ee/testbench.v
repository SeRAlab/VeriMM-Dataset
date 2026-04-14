`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg CE;
    reg D;
    reg R;
    reg S;
    wire Q1;
    wire Q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CE(CE),
        .D(D),
        .R(R),
        .S(S),
        .Q1(Q1),
        .Q2(Q2)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin
        R = 1; S = 0; CE = 0; D = 0;
        @(posedge C);
        @(negedge C);
        #2 R = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying active-high Reset (R) override...", test_num);
        reset_dut();
        R = 1; S = 0; CE = 1; D = 1;
        #5;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying active-high Set (S) override...", test_num);
        reset_dut();
        S = 1; R = 0; CE = 1; D = 0;
        #5;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Rising Edge capture (Q1) with CE=1...", test_num);
        reset_dut();
        CE = 1; D = 1;
        @(posedge C);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Falling Edge capture (Q2) with CE=1...", test_num);
        reset_dut();
        CE = 1; D = 1;
        @(negedge C);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Clock Enable (CE) functionality...", test_num);
        reset_dut();
        CE = 0; D = 1;
        @(posedge C);
        @(negedge C);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing dual edge independence...", test_num);
        reset_dut();
        CE = 1;
        D = 1;
        @(posedge C);
        #2 D = 0;
        @(negedge C);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Reset override during clock edge...", test_num);
        reset_dut();
        CE = 1; D = 1;
        @(posedge C);
        #2 R = 1;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing continuous sampling sequence...", test_num);
        reset_dut();
        CE = 1;
        D = 1; @(posedge C);
        D = 1; @(negedge C);
        D = 0; @(posedge C);
        D = 0; @(negedge C);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_Q1;
        input expected_Q2;
        begin
            if (expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2)) begin
                $display("PASS");
                $display("  Outputs: Q1=%b, Q2=%b",
                         Q1, Q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q1=%b, Q2=%b",
                         expected_Q1, expected_Q2);
                $display("  Got:      Q1=%b, Q2=%b",
                         Q1, Q2);
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
        $dumpvars(0,C, CE, D, R, S, Q1, Q2);
    end

endmodule
