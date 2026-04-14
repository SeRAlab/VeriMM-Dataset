`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i1;
    reg i2;
    reg i3;
    reg i4;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: i1=1, i2=0, i3=1, i4=0");
        i1 = 1; i2 = 0; i3 = 1; i4 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: i1=0, i2=1, i3=0, i4=1");
        i1 = 0; i2 = 1; i3 = 0; i4 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: i1=1, i2=1, i3=0, i4=1");
        i1 = 1; i2 = 1; i3 = 0; i4 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: i1=0, i2=0, i3=1, i4=1");
        i1 = 0; i2 = 0; i3 = 1; i4 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: i1=1, i2=0, i3=0, i4=0");
        i1 = 1; i2 = 0; i3 = 0; i4 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: i1=0, i2=1, i3=1, i4=0");
        i1 = 0; i2 = 1; i3 = 1; i4 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: i1=0, i2=1, i3=1, i4=1");
        i1 = 0; i2 = 1; i3 = 1; i4 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: i1=1, i2=0, i3=1, i4=1");
        i1 = 1; i2 = 0; i3 = 1; i4 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: i1=0, i2=0, i3=0, i4=1");
        i1 = 0; i2 = 0; i3 = 0; i4 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: i1=1, i2=1, i3=1, i4=0");
        i1 = 1; i2 = 1; i3 = 1; i4 = 0;
        #1;

        check_outputs(1'b0);
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
