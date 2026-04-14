`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
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
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .VGND(VGND),
        .VPWR(VPWR),
        .VNB(VNB),
        .VPB(VPB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs logic low (Power not good)", test_num);
        A1 = 0; A2 = 0; B1 = 0; B2 = 0;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input A1 high (Power good)", test_num);
        A1 = 1; A2 = 0; B1 = 0; B2 = 0;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input A2 high (Power good)", test_num);
        A1 = 0; A2 = 1; B1 = 0; B2 = 0;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input B1 high (Power good)", test_num);
        A1 = 0; A2 = 0; B1 = 1; B2 = 0;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input B2 high (Power good)", test_num);
        A1 = 0; A2 = 0; B1 = 0; B2 = 1;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple inputs high (A1 and B1)", test_num);
        A1 = 1; A2 = 0; B1 = 1; B2 = 0;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs high", test_num);
        A1 = 1; A2 = 1; B1 = 1; B2 = 1;
        VPWR = 1; VGND = 0;
        #1;

        check_outputs(1'b1, 1'b1);
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
