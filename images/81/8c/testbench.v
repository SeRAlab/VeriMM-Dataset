`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VPWR;
    wire VNB;
    wire VPB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VPWR(VPWR),
        .VNB(VNB),
        .VPB(VPB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal Operation (VPWR=1, VGND=0)", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Power Down (VPWR=0, VGND=0)", test_num);
            VPWR = 1'b0;
            VGND = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Ground Shift (VPWR=1, VGND=1)", test_num);
            VPWR = 1'b1;
            VGND = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reverse/Fault State (VPWR=0, VGND=1)", test_num);
            VPWR = 1'b0;
            VGND = 1'b1;

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
        input expected_VNB;
        input expected_VPB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VNB === (expected_VNB ^ VNB ^ expected_VNB) &&
                expected_VPB === (expected_VPB ^ VPB ^ expected_VPB)) begin
                $display("PASS");
                $display("  Outputs: VNB=%b, VPB=%b",
                         VNB, VPB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VNB=%b, VPB=%b",
                         expected_VNB, expected_VPB);
                $display("  Got:      VNB=%b, VPB=%b",
                         VNB, VPB);
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
