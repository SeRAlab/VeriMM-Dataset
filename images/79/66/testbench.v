`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR)
    );

    // Clock generation (10ns period)
    initial begin
        VGND = 0;
        forever #5 VGND = ~VGND;
    end

        task reset_dut;

        begin
            VNB = 0;
            VPB = 0;
            VPWR = 0;
            exp_VPWR = 0;
            exp_VPB = 0;
            repeat(2) @(posedge VGND);
            $display("System Reset Performed.");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Initial State Check");
            reset_dut();

            VNB = 0;
            exp_VPWR = 0;
            exp_VPB = 0;
            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: VNB Activation");
            reset_dut();
            @(posedge VGND);
            VNB = 1;
            exp_VPB = 1;
            exp_VPWR = 0;
            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Full Power Sequence");
            reset_dut();
            @(posedge VGND);
            VNB = 1;
            #10;


            exp_VPB = 1;
            exp_VPWR = 1;
            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Rising Edge Feedback on VPB");
            reset_dut();
            #5;
            VPB = 1;

            exp_VPB = 1;
            exp_VPWR = 0;
            #15;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Rising Edge Feedback on VPWR");
            reset_dut();
            #5;
            VPWR = 1;

            exp_VPWR = 1;
            exp_VPB = 1;
            #15;
            #1;

            check_outputs();
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,VGND, VNB, VPB, VPWR);
    end

endmodule
