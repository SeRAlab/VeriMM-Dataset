`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire HI;
    wire LO;

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
        .HI(HI),
        .LO(LO)
    );
    task testcase001;

        begin
            test_num = 1;
            VPWR = 0; VPB = 0; VGND = 0; VNB = 0;
            $display("Testcase %0d: All inputs low", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            VPWR = 1; VPB = 0; VGND = 0; VNB = 0;
            $display("Testcase %0d: HI condition met (VPWR=1, VPB=0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            VPWR = 0; VPB = 0; VGND = 1; VNB = 0;
            $display("Testcase %0d: LO condition met (VGND=1, VNB=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            VPWR = 1; VPB = 0; VGND = 1; VNB = 0;
            $display("Testcase %0d: Both HI and LO conditions met", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            VPWR = 1; VPB = 1; VGND = 1; VNB = 1;
            $display("Testcase %0d: Power inputs high but inhibited by VPB/VNB", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            VPWR = 0; VPB = 1; VGND = 0; VNB = 1;
            $display("Testcase %0d: VPB/VNB high, Power inputs low", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            VPWR = 1; VPB = 1; VGND = 0; VNB = 0;
            $display("Testcase %0d: VPWR high but inhibited by VPB", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            VPWR = 0; VPB = 0; VGND = 1; VNB = 1;
            $display("Testcase %0d: VGND high but inhibited by VNB", test_num);
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
        testcase008();
        
        
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
        input expected_HI;
        input expected_LO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HI === (expected_HI ^ HI ^ expected_HI) &&
                expected_LO === (expected_LO ^ LO ^ expected_LO)) begin
                $display("PASS");
                $display("  Outputs: HI=%b, LO=%b",
                         HI, LO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HI=%b, LO=%b",
                         expected_HI, expected_LO);
                $display("  Got:      HI=%b, LO=%b",
                         HI, LO);
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
