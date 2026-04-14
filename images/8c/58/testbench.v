`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        VGND = 0;
        forever #5 VGND = ~VGND;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;

            VPWR = 0;
            VPB = 0;
            VNB = 1;
            A1 = 0;
            A2 = 0;
            B1 = 0;
            B2 = 0;
            #15;

            VPWR = 1;
            VPB = 1;
            VNB = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Reach State 3 (Expect X=0)");

            repeat(3) @(posedge VGND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Reach State 4 (Expect X=1)");

            repeat(4) @(posedge VGND);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Cyclic Reach State 3 (11 cycles, Expect X=0)");
            repeat(11) @(posedge VGND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: Cyclic Reach State 4 (12 cycles, Expect X=1)");
            repeat(12) @(posedge VGND);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: State 4 with A/B inputs HIGH (Expect X=1)");
            A1 = 1; A2 = 1; B1 = 1; B2 = 1;
            repeat(4) @(posedge VGND);
            #2;
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
        $dumpvars(0,A1, A2, B1, B2, VGND, VNB, VPB, VPWR, X);
    end

endmodule
