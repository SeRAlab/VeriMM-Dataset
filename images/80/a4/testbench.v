`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg GATE;
    reg VGND;
    reg VPWR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .GATE(GATE),
        .VGND(VGND),
        .VPWR(VPWR),
        .Q(Q)
    );
    task testcase001;

        begin
            $display("Testcase 001: Latch transparent, input 0");
            test_num = 1;

            VPWR = 1;
            VGND = 0;
            GATE = 1;
            D = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Latch transparent, input 1");
            test_num = 2;

            VPWR = 1;
            VGND = 0;
            GATE = 1;
            D = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Latch hold value 1 while GATE is low");
            test_num = 3;

            VPWR = 1;
            VGND = 0;
            GATE = 1;
            D = 1;
            #10;

            GATE = 0;
            #5;

            D = 0;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Latch hold value 0 while GATE is low");
            test_num = 4;

            VPWR = 1;
            VGND = 0;
            GATE = 1;
            D = 0;
            #10;

            GATE = 0;
            #5;

            D = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transition from hold to transparent");
            test_num = 5;

            VPWR = 1;
            VGND = 0;
            GATE = 1;
            D = 1;
            #5;
            GATE = 0;
            D = 0;
            #10;

            GATE = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify output follows D during long GATE high period");
            test_num = 6;
            VPWR = 1;
            VGND = 0;
            GATE = 1;
            D = 0; #5;
            D = 1; #5;
            D = 0; #5;
            D = 1; #10;
            #1;

            check_outputs(1);
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
