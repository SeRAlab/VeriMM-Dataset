`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
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
        .A(A),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        VPB = 0;
        forever #5 VPB = ~VPB;
    end

        task reset_dut;

    begin
        A = 0;
        VPWR = 0;
        VGND = 0;
        VNB = 0;


        @(negedge VPB);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture '1' with VPWR=1", test_num);
        reset_dut();
        A = 1;
        VPWR = 1;
        @(posedge VPB);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture '0' with VPWR=1", test_num);
        reset_dut();
        A = 0;
        VPWR = 1;
        @(posedge VPB);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture '1' then set VPWR=0 (Power Aware)", test_num);
        reset_dut();
        A = 1;
        VPWR = 1;
        @(posedge VPB);
        #2;
        VPWR = 0;
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Change A without VPB rising edge", test_num);
        reset_dut();
        A = 1;
        VPWR = 1;
        @(posedge VPB);
        #2;
        A = 0;
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture '1' while VPWR is 0", test_num);
        reset_dut();
        A = 1;
        VPWR = 0;
        @(posedge VPB);
        #2;
        #1;

        check_outputs(0);
        VPWR = 1;
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple consecutive captures", test_num);
        reset_dut();
        VPWR = 1;

        A = 1;
        @(posedge VPB);
        #10;

        A = 0;
        @(posedge VPB);
        #2;
        #1;

        check_outputs(0);
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
        $dumpvars(0,A, VGND, VNB, VPB, VPWR, X);
    end

endmodule
