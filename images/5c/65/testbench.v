`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    reg [3:0] delay;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .delay(delay),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        VGND = 0;
        forever #5 VGND = ~VGND;
    end

        task reset_dut;

        begin
            A = 0;
            delay = 0;
            VPWR = 0;
            VPB = 1;
            VNB = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 1;
            delay = 4'd5;
            #10;
            VPWR = 1;
            #5;
            #1;
            $display("Testcase 001: A=1, Delay=5");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 0;
            delay = 4'd12;
            #10;
            VPWR = 1;
            #12;
            #1;
            $display("Testcase 002: A=0, Delay=12");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 1;
            delay = 4'd0;
            #10;
            VPWR = 1;
            #1;
            $display("Testcase 003: A=1, Delay=0");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 0;
            delay = 4'd15;
            #10;
            VPWR = 1;
            #15;
            #1;
            $display("Testcase 004: A=0, Delay=15");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 1;
            delay = 4'd8;
            #10;
            VPWR = 1;
            #2;
            A = 0;
            #6;
            #1;
            $display("Testcase 005: Capture A=1, then change A to 0 before delay expires");
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
        $dumpvars(0,A, VGND, VNB, VPB, VPWR, delay, X);
    end

endmodule
