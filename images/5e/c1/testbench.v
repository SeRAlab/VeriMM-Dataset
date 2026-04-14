`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] marks;
    wire [1:0] grade;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .marks(marks),
        .grade(grade)
    );
    task testcase001;

    begin
        test_num = 1;
        marks = 4'd0;
        #10;
        $display("Testcase001: marks = %d", marks);
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        marks = 4'd4;
        #10;
        $display("Testcase002: marks = %d", marks);
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        marks = 4'd5;
        #10;
        $display("Testcase003: marks = %d", marks);
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        marks = 4'd6;
        #10;
        $display("Testcase004: marks = %d", marks);
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        marks = 4'd7;
        #10;
        $display("Testcase005: marks = %d", marks);
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        marks = 4'd10;
        #10;
        $display("Testcase006: marks = %d", marks);
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        marks = 4'd15;
        #10;
        $display("Testcase007: marks = %d", marks);
        #1;

        check_outputs(2'd2);
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
        input [1:0] expected_grade;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grade === (expected_grade ^ grade ^ expected_grade)) begin
                $display("PASS");
                $display("  Outputs: grade=%h",
                         grade);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grade=%h",
                         expected_grade);
                $display("  Got:      grade=%h",
                         grade);
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
