`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg EN;
    wire Q_AND;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .Q_AND(Q_AND)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 0;
            D = 4'b0000;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Load 4'b1111 with EN=1");
            EN = 1;
            D = 4'b1111;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Load 4'b1110 with EN=1");
            EN = 1;
            D = 4'b1110;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Load 4'b1111 with EN=0");
            EN = 0;
            D = 4'b1111;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: EN 1->0 transition with D=4'b1111");
            EN = 1;
            D = 4'b1111;
            @(posedge CLK);
            #1;
            EN = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Load 4'b0111 with EN=1");
            EN = 1;
            D = 4'b0111;
            @(posedge CLK);
            #2;
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
        input expected_Q_AND;
        begin
            if (expected_Q_AND === (expected_Q_AND ^ Q_AND ^ expected_Q_AND)) begin
                $display("PASS");
                $display("  Outputs: Q_AND=%b",
                         Q_AND);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_AND=%b",
                         expected_Q_AND);
                $display("  Got:      Q_AND=%b",
                         Q_AND);
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
        $dumpvars(0,CLK, D, EN, Q_AND);
    end

endmodule
