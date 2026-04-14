`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg S0;
    reg S1;
    reg VNB;
    reg VPB;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S0(S0),
        .S1(S1),
        .VNB(VNB),
        .VPB(VPB),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: S0=0, S1=0 (Select is fixed to 0, output X should be S0)", test_num);

        VPB = 1;
        VNB = 0;

        S0 = 0;
        S1 = 0;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: S0=1, S1=0 (Select is fixed to 0, output X should be S0)", test_num);
        VPB = 1;
        VNB = 0;
        S0 = 1;
        S1 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: S0=0, S1=1 (Select is fixed to 0, output X should be S0, ignoring S1)", test_num);
        VPB = 1;
        VNB = 0;
        S0 = 0;
        S1 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: S0=1, S1=1 (Select is fixed to 0, output X should be S0)", test_num);
        VPB = 1;
        VNB = 0;
        S0 = 1;
        S1 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Randomizing S1 to ensure isolation", test_num);
        VPB = 1;
        VNB = 0;
        S0 = 1;
        S1 = 0; #5;
        S1 = 1; #5;
        S1 = 0;
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
