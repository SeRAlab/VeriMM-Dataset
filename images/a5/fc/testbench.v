`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg [3:0] y;
    wire Y0;
    wire Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .y(y),
        .Y0(Y0),
        .Y3(Y3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State R (y=0001), a=0 -> Expect Next State U (Y3=1, Y0=0)", test_num);
        y = 4'b0001;
        a = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State R (y=0001), a=1 -> Expect Next State S (Y3=0, Y0=0)", test_num);
        y = 4'b0001;
        a = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State S (y=0010), a=0 -> Expect Next State R (Y3=0, Y0=1)", test_num);
        y = 4'b0010;
        a = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State S (y=0010), a=1 -> Expect Next State T (Y3=0, Y0=0)", test_num);
        y = 4'b0010;
        a = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State T (y=0100), a=0 -> Expect Next State R (Y3=0, Y0=1)", test_num);
        y = 4'b0100;
        a = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State T (y=0100), a=1 -> Expect Next State U (Y3=1, Y0=0)", test_num);
        y = 4'b0100;
        a = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State U (y=1000), a=0 -> Expect Next State R (Y3=0, Y0=1)", test_num);
        y = 4'b1000;
        a = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: State U (y=1000), a=1 -> Expect Next State S (Y3=0, Y0=0)", test_num);
        y = 4'b1000;
        a = 1;
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
        input expected_Y0;
        input expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y3=%b",
                         Y0, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y3=%b",
                         expected_Y0, expected_Y3);
                $display("  Got:      Y0=%b, Y3=%b",
                         Y0, Y3);
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
