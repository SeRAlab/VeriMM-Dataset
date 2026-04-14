`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg y0;
    reg y1;
    reg y2;
    wire Z0;
    wire Z1;
    wire Z2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .Z0(Z0),
        .Z1(Z1),
        .Z2(Z2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs zero (w=0, y=000)", test_num);
        w = 0; y2 = 0; y1 = 0; y0 = 0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: w=0, y=010 (Intermediate state)", test_num);
        w = 0; y2 = 0; y1 = 1; y0 = 0;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: w=0, y=101 (State transition check)", test_num);
        w = 0; y2 = 1; y1 = 0; y0 = 1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: w=0, y=111 (Max inputs)", test_num);
        w = 0; y2 = 1; y1 = 1; y0 = 1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Control w=1, y=000", test_num);
        w = 1; y2 = 0; y1 = 0; y0 = 0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Control w=1, y=100", test_num);
        w = 1; y2 = 1; y1 = 0; y0 = 0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Control w=1, y=011", test_num);
        w = 1; y2 = 0; y1 = 1; y0 = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Control w=1, y=111", test_num);
        w = 1; y2 = 1; y1 = 1; y0 = 1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_Z0;
        input expected_Z1;
        input expected_Z2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z0 === (expected_Z0 ^ Z0 ^ expected_Z0) &&
                expected_Z1 === (expected_Z1 ^ Z1 ^ expected_Z1) &&
                expected_Z2 === (expected_Z2 ^ Z2 ^ expected_Z2)) begin
                $display("PASS");
                $display("  Outputs: Z0=%b, Z1=%b, Z2=%b",
                         Z0, Z1, Z2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z0=%b, Z1=%b, Z2=%b",
                         expected_Z0, expected_Z1, expected_Z2);
                $display("  Got:      Z0=%b, Z1=%b, Z2=%b",
                         Z0, Z1, Z2);
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
