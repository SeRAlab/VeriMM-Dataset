`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C0;
    reg C1;
    reg D0;
    reg D1;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C0(C0),
        .C1(C1),
        .D0(D0),
        .D1(D1),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C0 = 0;
        forever #5 C0 = ~C0;
    end

        task reset_dut;

    begin
        D0 = 0;
        D1 = 0;
        C1 = 0;

        @(negedge C0);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Capture D0=1 on C0 rising edge", test_num);
        reset_dut();
        D0 = 1;
        @(posedge C0);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Capture D1=1 on C1 rising edge", test_num);
        reset_dut();
        D1 = 1;
        #5 C1 = 1;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Update Q with D0=1 then D1=0", test_num);
        reset_dut();
        D0 = 1;
        @(posedge C0);
        #2;
        D1 = 0;
        #2 C1 = 1;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: D0 change without C0 edge (Q should remain 0)", test_num);
        reset_dut();
        D0 = 1;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Update Q with D1=1 then D0=0", test_num);
        reset_dut();
        D1 = 1;
        #3 C1 = 1;
        #2;
        D0 = 0;
        @(posedge C0);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,C0, C1, D0, D1, Q);
    end

endmodule
