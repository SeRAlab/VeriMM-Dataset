`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg TE_B;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .TE_B(TE_B),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        TE_B = 0;
        forever #5 TE_B = ~TE_B;
    end

        task reset_dut;

        begin
            A = 0;

            VPB = 1;
            VPWR = 1;
            VGND = 0;
            VNB = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Verifying initial high-impedance state before TE_B rising edge...", test_num);
            A = 1'b1;


            #1;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Enabling driver via TE_B rising edge with A=1...", test_num);
            A = 1'b1;

            @(posedge TE_B);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verifying Z follows A when mask is active (A=0)...", test_num);

            A = 1'b0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Verifying Z follows A when mask is active (A=1)...", test_num);
            A = 1'b1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Verifying mask remains active across multiple TE_B cycles...", test_num);

            @(posedge TE_B);
            A = 1'b0;
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
        input expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
        $dumpvars(0,A, TE_B, VGND, VNB, VPB, VPWR, Z);
    end

endmodule
