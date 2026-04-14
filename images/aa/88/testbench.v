`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] t;
    reg v;
    wire T2;
    wire T4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .t(t),
        .v(v),
        .T2(T2),
        .T4(T4)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State A (t=0001), v=0", test_num);
        t = 4'b0001;
        v = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State A (t=0001), v=1", test_num);
        t = 4'b0001;
        v = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State B (t=0010), v=0", test_num);
        t = 4'b0010;
        v = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State B (t=0010), v=1", test_num);
        t = 4'b0010;
        v = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State C (t=0100), v=0", test_num);
        t = 4'b0100;
        v = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State C (t=0100), v=1", test_num);
        t = 4'b0100;
        v = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State D (t=1000), v=0", test_num);
        t = 4'b1000;
        v = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: State D (t=1000), v=1", test_num);
        t = 4'b1000;
        v = 1;
        #1;

        check_outputs(0, 0);
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
        input expected_T2;
        input expected_T4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_T2 === (expected_T2 ^ T2 ^ expected_T2) &&
                expected_T4 === (expected_T4 ^ T4 ^ expected_T4)) begin
                $display("PASS");
                $display("  Outputs: T2=%b, T4=%b",
                         T2, T4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T2=%b, T4=%b",
                         expected_T2, expected_T4);
                $display("  Got:      T2=%b, T4=%b",
                         T2, T4);
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
