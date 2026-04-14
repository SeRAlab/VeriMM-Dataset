`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input1;
    reg [1:0] input2;
    reg input3;
    reg input4;
    reg input5;
    reg input6;
    reg input7;
    reg input8;
    wire output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .input5(input5),
        .input6(input6),
        .input7(input7),
        .input8(input8),
        .output1(output1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Condition 1 - Boundary (input1=6, input2=2)");
            input1 = 4'd6;
            input2 = 2'd2;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Condition 1 - Below boundary (input1=5, input2=2)");
            input1 = 4'd5;
            input2 = 2'd2;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Condition 1 - Correct input1, wrong input2 (input1=8, input2=1)");
            input1 = 4'd8;
            input2 = 2'd1;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Condition 2 - True (input3=1, input4=0)");
            input1 = 4'd0;
            input2 = 2'd0;
            input3 = 1'b1;
            input4 = 1'b0;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Condition 2 - False (input3=1, input4=1)");
            input1 = 4'd0;
            input2 = 2'd0;
            input3 = 1'b1;
            input4 = 1'b1;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Condition 3 - All HIGH (inputs 5-8 = 1)");
            input1 = 4'd0;
            input2 = 2'd0;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b1;
            input6 = 1'b1;
            input7 = 1'b1;
            input8 = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Condition 3 - One LOW (input7=0)");
            input1 = 4'd0;
            input2 = 2'd0;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b1;
            input6 = 1'b1;
            input7 = 1'b0;
            input8 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Condition 1 - Max input1 (input1=15, input2=2)");
            input1 = 4'd15;
            input2 = 2'd2;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Multiple conditions met (Cond 1 and 2)");
            input1 = 4'd7;
            input2 = 2'd2;
            input3 = 1'b1;
            input4 = 1'b0;
            input5 = 1'b0;
            input6 = 1'b0;
            input7 = 1'b0;
            input8 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: All conditions False");
            input1 = 4'd2;
            input2 = 2'd0;
            input3 = 1'b0;
            input4 = 1'b1;
            input5 = 1'b1;
            input6 = 1'b0;
            input7 = 1'b1;
            input8 = 1'b0;
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
        input expected_output1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%b",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%b",
                         expected_output1);
                $display("  Got:      output1=%b",
                         output1);
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
