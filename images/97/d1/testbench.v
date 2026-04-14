`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] counter;
    wire i1;
    wire i2;
    wire i3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .counter(counter),
        .i1(i1),
        .i2(i2),
        .i3(i3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Counter = 4'b0000 (Bits 2,1 are 00)", test_num);
        counter = 4'b0000;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Counter = 4'b0001 (Bits 2,1 are 00)", test_num);
        counter = 4'b0001;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Counter = 4'b0010 (Bits 2,1 are 01)", test_num);
        counter = 4'b0010;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Counter = 4'b0011 (Bits 2,1 are 01)", test_num);
        counter = 4'b0011;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Counter = 4'b0100 (Bits 2,1 are 10)", test_num);
        counter = 4'b0100;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Counter = 4'b0110 (Bits 2,1 are 11)", test_num);
        counter = 4'b0110;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Counter = 4'b1000 (Bits 2,1 are 00)", test_num);
        counter = 4'b1000;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Counter = 4'b1111 (Bits 2,1 are 11)", test_num);
        counter = 4'b1111;
        #1;

        check_outputs(0, 0, 1);
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
        input expected_i1;
        input expected_i2;
        input expected_i3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i1 === (expected_i1 ^ i1 ^ expected_i1) &&
                expected_i2 === (expected_i2 ^ i2 ^ expected_i2) &&
                expected_i3 === (expected_i3 ^ i3 ^ expected_i3)) begin
                $display("PASS");
                $display("  Outputs: i1=%b, i2=%b, i3=%b",
                         i1, i2, i3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i1=%b, i2=%b, i3=%b",
                         expected_i1, expected_i2, expected_i3);
                $display("  Got:      i1=%b, i2=%b, i3=%b",
                         i1, i2, i3);
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
