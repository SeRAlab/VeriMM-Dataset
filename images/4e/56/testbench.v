`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cIn;
    reg in1;
    reg in2;
    wire cOut;
    wire sOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cIn(cIn),
        .in1(in1),
        .in2(in2),
        .cOut(cOut),
        .sOut(sOut)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 0; in2 = 0; cIn = 0;
        $display("Testcase %0d: 0 + 0 + cIn(0)", test_num);
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 0; in2 = 0; cIn = 1;
        $display("Testcase %0d: 0 + 0 + cIn(1)", test_num);
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 0; in2 = 1; cIn = 0;
        $display("Testcase %0d: 0 + 1 + cIn(0)", test_num);
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 0; in2 = 1; cIn = 1;
        $display("Testcase %0d: 0 + 1 + cIn(1)", test_num);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 1; in2 = 0; cIn = 0;
        $display("Testcase %0d: 1 + 0 + cIn(0)", test_num);
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 1; in2 = 0; cIn = 1;
        $display("Testcase %0d: 1 + 0 + cIn(1)", test_num);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 1; in2 = 1; cIn = 0;
        $display("Testcase %0d: 1 + 1 + cIn(0)", test_num);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 1; in2 = 1; cIn = 1;
        $display("Testcase %0d: 1 + 1 + cIn(1)", test_num);
        #1;

        check_outputs(1, 1);
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
        input expected_cOut;
        input expected_sOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cOut === (expected_cOut ^ cOut ^ expected_cOut) &&
                expected_sOut === (expected_sOut ^ sOut ^ expected_sOut)) begin
                $display("PASS");
                $display("  Outputs: cOut=%b, sOut=%b",
                         cOut, sOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cOut=%b, sOut=%b",
                         expected_cOut, expected_sOut);
                $display("  Got:      cOut=%b, sOut=%b",
                         cOut, sOut);
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
