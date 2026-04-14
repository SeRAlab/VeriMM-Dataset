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
        $display("Testcase 001: Incrementing 00 to 01");
        count_i = 2'b00;
        op = 1'b1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Incrementing 01 to 10");
        count_i = 2'b01;
        op = 1'b1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Incrementing 10 to 11");
        count_i = 2'b10;
        op = 1'b1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Incrementing 11 (Saturation) to 11");
        count_i = 2'b11;
        op = 1'b1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Decrementing 11 to 10");
        count_i = 2'b11;
        op = 1'b0;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Decrementing 10 to 01");
        count_i = 2'b10;
        op = 1'b0;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Decrementing 01 to 00");
        count_i = 2'b01;
        op = 1'b0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Decrementing 00 (Saturation) to 00");
        count_i = 2'b00;
        op = 1'b0;
        #1;

        check_outputs(2'b00);
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
