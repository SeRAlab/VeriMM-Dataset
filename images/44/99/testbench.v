`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg TBS;
    reg XA1;
    reg XA2;
    reg XAB;
    reg XB1;
    reg XB2;
    reg XSL;
    wire XZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .TBS(TBS),
        .XA1(XA1),
        .XA2(XA2),
        .XAB(XAB),
        .XB1(XB1),
        .XB2(XB2),
        .XSL(XSL),
        .XZ(XZ)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: TBS=0 (Output Disable)", test_num);
        TBS = 0;
        XAB = 1; XSL = 1;
        XA1 = 1; XA2 = 1; XB1 = 1; XB2 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select XA1 (0,0), Data=1", test_num);
        TBS = 1;
        XAB = 0; XSL = 0;
        XA1 = 1; XA2 = 0; XB1 = 0; XB2 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select XA1 (0,0), Data=0", test_num);
        TBS = 1;
        XAB = 0; XSL = 0;
        XA1 = 0; XA2 = 1; XB1 = 1; XB2 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select XA2 (0,1), Data=1", test_num);
        TBS = 1;
        XAB = 0; XSL = 1;
        XA1 = 0; XA2 = 1; XB1 = 0; XB2 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select XB1 (1,0), Data=1", test_num);
        TBS = 1;
        XAB = 1; XSL = 0;
        XA1 = 0; XA2 = 0; XB1 = 1; XB2 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select XB2 (1,1), Data=1", test_num);
        TBS = 1;
        XAB = 1; XSL = 1;
        XA1 = 0; XA2 = 0; XB1 = 0; XB2 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select XB2 (1,1), Data=0", test_num);
        TBS = 1;
        XAB = 1; XSL = 1;
        XA1 = 1; XA2 = 1; XB1 = 1; XB2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: TBS Toggle while path is active", test_num);
        XAB = 0; XSL = 0; XA1 = 1;
        TBS = 0;
        #1;
        TBS = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Selection change while TBS=0", test_num);
        TBS = 0;
        XA1 = 1; XA2 = 1; XB1 = 1; XB2 = 1;
        XAB = 0; XSL = 0; #1;
        XAB = 1; XSL = 1; #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Unselected Input Noise Check", test_num);
        TBS = 1;
        XAB = 0; XSL = 0;
        XA1 = 1;
        XA2 = 0; XB1 = 0; XB2 = 0;
        #1;
        XA2 = 1; XB1 = 1; XB2 = 1;
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
        testcase010();
        
        
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
        input expected_XZ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_XZ === (expected_XZ ^ XZ ^ expected_XZ)) begin
                $display("PASS");
                $display("  Outputs: XZ=%b",
                         XZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: XZ=%b",
                         expected_XZ);
                $display("  Got:      XZ=%b",
                         XZ);
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
