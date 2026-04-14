`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] count_i;
    reg op;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count_i(count_i),
        .op(op),
        .count(count)
    );
    task testcase001;

    begin
        test_num = 1;
        count_i = 2'b00; op = 1'b1;
        $display("Test %0d: Increment from 00 (Expect 01)", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        count_i = 2'b01; op = 1'b1;
        $display("Test %0d: Increment from 01 (Expect 10)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        count_i = 2'b10; op = 1'b1;
        $display("Test %0d: Increment from 10 (Saturate at 10)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        count_i = 2'b11; op = 1'b1;
        $display("Test %0d: Increment from 11 (Saturate at 11)", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        count_i = 2'b00; op = 1'b0;
        $display("Test %0d: Reset/Maintain from 00 (Expect 00)", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        count_i = 2'b01; op = 1'b0;
        $display("Test %0d: Reset from 01 (Expect 00)", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        count_i = 2'b10; op = 1'b0;
        $display("Test %0d: Decrement from 10 (Expect 01)", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        count_i = 2'b11; op = 1'b0;
        $display("Test %0d: Decrement from 11 (Expect 10)", test_num);
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
