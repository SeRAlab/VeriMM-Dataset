`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DIODE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire D1;
    wire D2;
    wire D3;
    wire D4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIODE(DIODE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Diode Forward-Biased (DIODE=1)");
            test_num = 1;

            VPWR = 1;
            VGND = 0;
            VPB = 1;
            VNB = 0;
            DIODE = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Diode Reverse-Biased (DIODE=0)");
            test_num = 2;

            VPWR = 1;
            VGND = 0;
            VPB = 1;
            VNB = 0;
            DIODE = 1'b0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Transition from Forward to Reverse Bias");
            test_num = 3;

            DIODE = 1'b1;
            #10;

            DIODE = 1'b0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Transition from Reverse to Forward Bias");
            test_num = 4;

            DIODE = 1'b0;
            #10;

            DIODE = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
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
        input expected_D1;
        input expected_D2;
        input expected_D3;
        input expected_D4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_D4 === (expected_D4 ^ D4 ^ expected_D4)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, D2=%b, D3=%b, D4=%b",
                         D1, D2, D3, D4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, D2=%b, D3=%b, D4=%b",
                         expected_D1, expected_D2, expected_D3, expected_D4);
                $display("  Got:      D1=%b, D2=%b, D3=%b, D4=%b",
                         D1, D2, D3, D4);
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
