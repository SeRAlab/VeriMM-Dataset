`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg C1;
    reg D1;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .C1(C1),
        .D1(D1),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All logic inputs High (A1=1, A2=1, B1=1, C1=1)", test_num);

        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;

        A1 = 1'b1; A2 = 1'b1; B1 = 1'b1; C1 = 1'b1; D1 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All logic inputs Low (A1=0, A2=0, B1=0, C1=0)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b0; A2 = 1'b0; B1 = 1'b0; C1 = 1'b0; D1 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A group High, B/C group Low (A1=1, A2=1, B1=0, C1=0)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b1; A2 = 1'b1; B1 = 1'b0; C1 = 1'b0; D1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A group Low, B/C group High (A1=0, A2=0, B1=1, C1=1)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b0; A2 = 1'b0; B1 = 1'b1; C1 = 1'b1; D1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Partial A match, B/C group High (A1=1, A2=0, B1=1, C1=1)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b1; A2 = 1'b0; B1 = 1'b1; C1 = 1'b1; D1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A group High, Partial B/C match (A1=1, A2=1, B1=1, C1=0)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b1; A2 = 1'b1; B1 = 1'b1; C1 = 1'b0; D1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed inputs (A1=1, A2=0, B1=0, C1=1)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b1; A2 = 1'b0; B1 = 1'b0; C1 = 1'b1; D1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All logic High, D1 toggled (A1=1, A2=1, B1=1, C1=1, D1=1)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b1; A2 = 1'b1; B1 = 1'b1; C1 = 1'b1; D1 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All logic Low, D1 toggled (A1=0, A2=0, B1=0, C1=0, D1=1)", test_num);
        VPWR = 1'b1; VGND = 1'b0; VPB = 1'b1; VNB = 1'b0;
        A1 = 1'b0; A2 = 1'b0; B1 = 1'b0; C1 = 1'b0; D1 = 1'b1;
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
