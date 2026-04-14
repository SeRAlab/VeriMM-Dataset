`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg EN;
    wire Q;
    wire Q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .EN(EN),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin
            D = 0;

            if (EN === 0) @(posedge EN);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            D = 1;
            #2;
            $display("Testcase 001: Transparent Mode (Set High)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            D = 1;
            #2;
            D = 0;
            #2;
            $display("Testcase 002: Transparent Mode (Set Low)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            D = 1;
            #2;

            @(negedge EN);
            #1;

            D = 0;
            #2;
            $display("Testcase 003: Latch Mode (Hold High)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            D = 0;
            #2;

            @(negedge EN);
            #1;

            D = 1;
            #2;
            $display("Testcase 004: Latch Mode (Hold Low)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge EN);
            D = 1; #1;
            D = 0; #1;
            D = 1; #1;
            $display("Testcase 005: Transparency Toggle (Multiple D changes)");
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_Q_bar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_bar === (expected_Q_bar ^ Q_bar ^ expected_Q_bar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_bar=%b",
                         Q, Q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_bar=%b",
                         expected_Q, expected_Q_bar);
                $display("  Got:      Q=%b, Q_bar=%b",
                         Q, Q_bar);
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
        $dumpvars(0,D, EN, Q, Q_bar);
    end

endmodule
