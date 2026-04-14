`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg S;
    reg rst;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .S(S),
        .rst(rst),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        S = 0;
        forever #5 S = ~S;
    end

        task reset_dut;

    begin
        rst = 1;
        A0 = 0;
        A1 = 0;

        @(posedge S);
        #2;
        rst = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        A0 = 1;
        A1 = 1;
        rst = 1;
        @(posedge S);
        #2;
        #1;

        check_outputs(1'b0);
        rst = 0;
        #2;
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        A1 = 1;
        A0 = 0;
        @(posedge S);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        A1 = 0;
        A0 = 1;
        @(posedge S);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        A1 = 1;
        @(posedge S);
        #2;
        rst = 1;
        #1;
        #1;

        check_outputs(1'b0);
        rst = 0;
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        A1 = 1;
        @(posedge S);
        #2;
        A1 = 0;
        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
        $dumpvars(0,A0, A1, S, rst, X);
    end

endmodule
