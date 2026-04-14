`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] alu_op;
    reg [3:0] funct;
    wire JRControl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .funct(funct),
        .JRControl(JRControl)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Matching case {alu_op=2'b00, funct=4'b1000}", test_num);
            alu_op = 2'b00;
            funct = 4'b1000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros {alu_op=2'b00, funct=4'b0000}", test_num);
            alu_op = 2'b00;
            funct = 4'b0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Correct funct, wrong alu_op {alu_op=2'b01, funct=4'b1000}", test_num);
            alu_op = 2'b01;
            funct = 4'b1000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Correct alu_op, wrong funct {alu_op=2'b00, funct=4'b1111}", test_num);
            alu_op = 2'b00;
            funct = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones {alu_op=2'b11, funct=4'b1111}", test_num);
            alu_op = 2'b11;
            funct = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary mismatch {alu_op=2'b10, funct=4'b1000}", test_num);
            alu_op = 2'b10;
            funct = 4'b1000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random mismatch {alu_op=2'b00, funct=4'b1001}", test_num);
            alu_op = 2'b00;
            funct = 4'b1001;
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
        input expected_JRControl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_JRControl === (expected_JRControl ^ JRControl ^ expected_JRControl)) begin
                $display("PASS");
                $display("  Outputs: JRControl=%b",
                         JRControl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: JRControl=%b",
                         expected_JRControl);
                $display("  Got:      JRControl=%b",
                         JRControl);
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
