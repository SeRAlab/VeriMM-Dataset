`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_1;
    reg input_2;
    reg input_3;
    reg input_4;
    wire output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .input_3(input_3),
        .input_4(input_4),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs LOW", test_num);
            input_1 = 0; input_2 = 0; input_3 = 0; input_4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: input_1 and input_2 HIGH (Consecutive)", test_num);
            input_1 = 1; input_2 = 1; input_3 = 0; input_4 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: input_2 and input_3 HIGH (Consecutive)", test_num);
            input_1 = 0; input_2 = 1; input_3 = 1; input_4 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: input_3 and input_4 HIGH (Consecutive)", test_num);
            input_1 = 0; input_2 = 0; input_3 = 1; input_4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating inputs (1,0,1,0) - Not consecutive", test_num);
            input_1 = 1; input_2 = 0; input_3 = 1; input_4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating inputs (0,1,0,1) - Not consecutive", test_num);
            input_1 = 0; input_2 = 1; input_3 = 0; input_4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Ends HIGH (1,0,0,1) - Not consecutive", test_num);
            input_1 = 1; input_2 = 0; input_3 = 0; input_4 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All inputs HIGH", test_num);
            input_1 = 1; input_2 = 1; input_3 = 1; input_4 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Single input HIGH", test_num);
            input_1 = 0; input_2 = 1; input_3 = 0; input_4 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Triple consecutive inputs HIGH (1,1,1,0)", test_num);
            input_1 = 1; input_2 = 1; input_3 = 1; input_4 = 0;
            #1;

            check_outputs(1);
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
        input expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%b",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%b",
                         expected_output_signal);
                $display("  Got:      output_signal=%b",
                         output_signal);
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
