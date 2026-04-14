`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_1;
    reg input_10;
    reg input_2;
    reg input_3;
    reg input_4;
    reg input_5;
    reg input_6;
    reg input_7;
    reg input_8;
    reg input_9;
    wire output_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_10(input_10),
        .input_2(input_2),
        .input_3(input_3),
        .input_4(input_4),
        .input_5(input_5),
        .input_6(input_6),
        .input_7(input_7),
        .input_8(input_8),
        .input_9(input_9),
        .output_1(output_1)
    );
    task reset_inputs;

        begin
            input_1 = 0; input_2 = 0; input_3 = 0; input_4 = 0; input_5 = 0;
            input_6 = 0; input_7 = 0; input_8 = 0; input_9 = 0; input_10 = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_inputs();
            $display("Test %0d: All inputs LOW", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_inputs();
            input_1 = 1;
            $display("Test %0d: input_1 HIGH", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_inputs();
            input_2 = 1; input_3 = 1;
            $display("Test %0d: input_2 and input_3 HIGH", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_inputs();
            input_2 = 1;
            $display("Test %0d: input_2 HIGH, input_3 LOW", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_inputs();
            input_4 = 1;
            $display("Test %0d: input_4 HIGH", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_inputs();
            input_5 = 1;
            $display("Test %0d: input_5 HIGH", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_inputs();
            input_6 = 1; input_7 = 1; input_8 = 1;
            $display("Test %0d: input_6, 7, 8 HIGH", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_inputs();
            input_6 = 1; input_7 = 1;
            $display("Test %0d: input_6, 7 HIGH, 8 LOW", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_inputs();
            input_9 = 1; input_10 = 1;
            $display("Test %0d: input_9 and 10 HIGH", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_inputs();
            input_1 = 1;
            input_9 = 1;
            input_10 = 1;
            $display("Test %0d: Multiple conditions (1 and 5) met", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_output_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_1 === (expected_output_1 ^ output_1 ^ expected_output_1)) begin
                $display("PASS");
                $display("  Outputs: output_1=%b",
                         output_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_1=%b",
                         expected_output_1);
                $display("  Got:      output_1=%b",
                         output_1);
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
