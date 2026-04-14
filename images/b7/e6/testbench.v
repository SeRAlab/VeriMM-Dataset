`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1_N;
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
        .A1(A1),
        .A2(A2),
        .B1_N(B1_N),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );
    task reset_inputs;

    begin
        A1 = 0;
        A2 = 0;
        B1_N = 1;
        VGND = 0;
        VNB = 0;
        VPB = 0;
        VPWR = 0;
    end
        endtask

    task testcase001;

    begin
        reset_inputs();
        test_num = 1;
        $display("Testcase %0d: Default condition (none of the rules met)", test_num);




        #1;





        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        test_num = 2;
        $display("Testcase %0d: Condition A1=1, A2=1", test_num);
        A1 = 1;
        A2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        test_num = 3;
        $display("Testcase %0d: Condition B1_N=0 (Forced low)", test_num);
        B1_N = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        test_num = 4;
        $display("Testcase %0d: Power conditions met (VPWR=1, VGND=0)", test_num);
        VPWR = 1;
        VGND = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        test_num = 5;
        $display("Testcase %0d: Bias conditions met (VPB=1, VNB=0)", test_num);
        VPB = 1;
        VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        reset_inputs();
        test_num = 6;
        $display("Testcase %0d: Conflict B1_N=0 vs A1=1, A2=1", test_num);
        B1_N = 0;
        A1 = 1;
        A2 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        reset_inputs();
        test_num = 7;
        $display("Testcase %0d: Conflict Power (1) vs Bias (0)", test_num);
        VPWR = 1;
        VGND = 0;
        VPB = 1;
        VNB = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        reset_inputs();
        test_num = 8;
        $display("Testcase %0d: Partial Rule 1 (A1=1 only)", test_num);
        A1 = 1;
        A2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        reset_inputs();
        test_num = 9;
        $display("Testcase %0d: Power condition not fully met (VGND=1)", test_num);
        VPWR = 1;
        VGND = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        reset_inputs();
        test_num = 10;
        $display("Testcase %0d: Bias condition not fully met (VNB=1)", test_num);
        VPB = 1;
        VNB = 1;
        #1;

        check_outputs(1);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
