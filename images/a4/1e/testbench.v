`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a__0;
    reg a__1;
    reg a__3;
    reg b__0;
    reg b__2;
    wire n__35;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a__0(a__0),
        .a__1(a__1),
        .a__3(a__3),
        .b__0(b__0),
        .b__2(b__2),
        .n__35(n__35)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs LOW (Expect n__35=1)", test_num);
        a__0 = 0; a__1 = 0; a__3 = 0; b__0 = 0; b__2 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: a__3 is HIGH (Expect n__35=0)", test_num);
        a__0 = 0; a__1 = 0; a__3 = 1; b__0 = 0; b__2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: b__2 is HIGH (Expect n__35=0)", test_num);
        a__0 = 0; a__1 = 0; a__3 = 0; b__0 = 0; b__2 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: b__0 is HIGH (Expect n__35=0)", test_num);
        a__0 = 0; a__1 = 0; a__3 = 0; b__0 = 1; b__2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: a__0 is HIGH (Expect n__35=0)", test_num);
        a__0 = 1; a__1 = 0; a__3 = 0; b__0 = 0; b__2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: a__1 is HIGH (Expect n__35=0)", test_num);
        a__0 = 0; a__1 = 1; a__3 = 0; b__0 = 0; b__2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Multiple inputs HIGH including a__3 (Expect n__35=0)", test_num);
        a__0 = 1; a__1 = 0; a__3 = 1; b__0 = 1; b__2 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Multiple condition inputs HIGH (Expect n__35=0)", test_num);
        a__0 = 0; a__1 = 1; a__3 = 0; b__0 = 1; b__2 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: All inputs HIGH (Expect n__35=0)", test_num);
        a__0 = 1; a__1 = 1; a__3 = 1; b__0 = 1; b__2 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Edge case, switching from HIGH to LOW (Expect n__35=1)", test_num);
        a__0 = 0; a__1 = 0; a__3 = 0; b__0 = 0; b__2 = 0;
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
        input expected_n__35;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n__35 === (expected_n__35 ^ n__35 ^ expected_n__35)) begin
                $display("PASS");
                $display("  Outputs: n__35=%b",
                         n__35);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n__35=%b",
                         expected_n__35);
                $display("  Got:      n__35=%b",
                         n__35);
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
