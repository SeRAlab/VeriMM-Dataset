`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg q0;
    reg q1;
    reg x;
    reg z;
    wire d0;
    wire d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q0(q0),
        .q1(q1),
        .x(x),
        .z(z),
        .d0(d0),
        .d1(d1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        q1 = 0; q0 = 0; x = 0; z = 0;
        $display("Testcase %0d: Inputs q1=0, q0=0, x=0", test_num);
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        q1 = 0; q0 = 0; x = 1; z = 1;
        $display("Testcase %0d: Inputs q1=0, q0=0, x=1", test_num);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        q1 = 0; q0 = 1; x = 0; z = 0;
        $display("Testcase %0d: Inputs q1=0, q0=1, x=0", test_num);
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        q1 = 0; q0 = 1; x = 1; z = 1;
        $display("Testcase %0d: Inputs q1=0, q0=1, x=1", test_num);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        q1 = 1; q0 = 0; x = 0; z = 0;
        $display("Testcase %0d: Inputs q1=1, q0=0, x=0", test_num);
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        q1 = 1; q0 = 0; x = 1; z = 1;
        $display("Testcase %0d: Inputs q1=1, q0=0, x=1", test_num);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        q1 = 1; q0 = 1; x = 0; z = 0;
        $display("Testcase %0d: Inputs q1=1, q0=1, x=0", test_num);
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        q1 = 1; q0 = 1; x = 1; z = 1;
        $display("Testcase %0d: Inputs q1=1, q0=1, x=1", test_num);
        #1;

        check_outputs(1, 0);
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
        input expected_d0;
        input expected_d1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1)) begin
                $display("PASS");
                $display("  Outputs: d0=%b, d1=%b",
                         d0, d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%b, d1=%b",
                         expected_d0, expected_d1);
                $display("  Got:      d0=%b, d1=%b",
                         d0, d1);
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
