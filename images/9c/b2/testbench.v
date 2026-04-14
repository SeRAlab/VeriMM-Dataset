`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_signal_1;
    reg input_signal_2;
    reg input_signal_3;
    reg input_signal_4;
    reg input_signal_5;
    wire output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_signal_1(input_signal_1),
        .input_signal_2(input_signal_2),
        .input_signal_3(input_signal_3),
        .input_signal_4(input_signal_4),
        .input_signal_5(input_signal_5),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Signals Low (00000)", test_num);
        input_signal_1 = 0; input_signal_2 = 0; input_signal_3 = 0; input_signal_4 = 0; input_signal_5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Signals High (11111)", test_num);
        input_signal_1 = 1; input_signal_2 = 1; input_signal_3 = 1; input_signal_4 = 1; input_signal_5 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Signal 1 Only (10000)", test_num);
        input_signal_1 = 1; input_signal_2 = 0; input_signal_3 = 0; input_signal_4 = 0; input_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Signal 2 Only (01000)", test_num);
        input_signal_1 = 0; input_signal_2 = 1; input_signal_3 = 0; input_signal_4 = 0; input_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signal 3 High, 4 Low (00100)", test_num);
        input_signal_1 = 0; input_signal_2 = 0; input_signal_3 = 1; input_signal_4 = 0; input_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signal 3 and 4 High (00110)", test_num);
        input_signal_1 = 0; input_signal_2 = 0; input_signal_3 = 1; input_signal_4 = 1; input_signal_5 = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Signal 5 Only (00001)", test_num);
        input_signal_1 = 0; input_signal_2 = 0; input_signal_3 = 0; input_signal_4 = 0; input_signal_5 = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complex Mix (10101)", test_num);
        input_signal_1 = 1; input_signal_2 = 0; input_signal_3 = 1; input_signal_4 = 0; input_signal_5 = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complex Mix (01010)", test_num);
        input_signal_1 = 0; input_signal_2 = 1; input_signal_3 = 0; input_signal_4 = 1; input_signal_5 = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Symmetric (11001)", test_num);
        input_signal_1 = 1; input_signal_2 = 1; input_signal_3 = 0; input_signal_4 = 0; input_signal_5 = 1;
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
