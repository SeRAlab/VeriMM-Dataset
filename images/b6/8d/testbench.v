`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire VCC;
    wire VDD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .VCC(VCC),
        .VDD(VDD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VPB=0, VPWR=0, VNB=0, VGND=0 (Outputs should be 0,0)", test_num);
            VPB = 1'b0;
            VPWR = 1'b0;
            VNB = 1'b0;
            VGND = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VPB=0, VPWR=1, VNB=1, VGND=0 (Outputs should be 0,0)", test_num);
            VPB = 1'b0;
            VPWR = 1'b1;
            VNB = 1'b1;
            VGND = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VPB=1, VPWR=1, VNB=0 (VCC should be 1, VDD 0)", test_num);
            VPB = 1'b1;
            VPWR = 1'b1;
            VNB = 1'b0;
            VGND = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VPB=1, VPWR=0, VNB=1 (VCC should be 0, VDD 1)", test_num);
            VPB = 1'b1;
            VPWR = 1'b0;
            VNB = 1'b1;
            VGND = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VPB=1, VPWR=0, VNB=0 (Outputs should be 0,0)", test_num);
            VPB = 1'b1;
            VPWR = 1'b0;
            VNB = 1'b0;
            VGND = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VPB=1, VPWR=1, VNB=1 (Priority check - Expecting VCC HIGH)", test_num);
            VPB = 1'b1;
            VPWR = 1'b1;
            VNB = 1'b1;
            VGND = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle VPB while other inputs are HIGH", test_num);
            VPWR = 1'b1;
            VNB = 1'b0;
            VGND = 1'b0;
            VPB = 1'b1;
            #5;
            VPB = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
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
        testcase007();
        
        
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
        input expected_VCC;
        input expected_VDD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VCC === (expected_VCC ^ VCC ^ expected_VCC) &&
                expected_VDD === (expected_VDD ^ VDD ^ expected_VDD)) begin
                $display("PASS");
                $display("  Outputs: VCC=%b, VDD=%b",
                         VCC, VDD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VCC=%b, VDD=%b",
                         expected_VCC, expected_VDD);
                $display("  Got:      VCC=%b, VDD=%b",
                         VCC, VDD);
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
