`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg input1;
    reg input2;
    reg input3;
    reg input4;
    wire output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .output1(output1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=0, all inputs=0. Expected output1=0", test_num);
            enable = 0;
            input1 = 0; input2 = 0; input3 = 0; input4 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=0, all inputs=1. Expected output1=0 (disable priority)", test_num);
            enable = 0;
            input1 = 1; input2 = 1; input3 = 1; input4 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, all inputs=0. Expected output1=0", test_num);
            enable = 1;
            input1 = 0; input2 = 0; input3 = 0; input4 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, input1=1. Expected output1=1", test_num);
            enable = 1;
            input1 = 1; input2 = 0; input3 = 0; input4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, input2=1. Expected output1=1", test_num);
            enable = 1;
            input1 = 0; input2 = 1; input3 = 0; input4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, input3=1. Expected output1=1", test_num);
            enable = 1;
            input1 = 0; input2 = 0; input3 = 1; input4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, input4=1. Expected output1=1", test_num);
            enable = 1;
            input1 = 0; input2 = 0; input3 = 0; input4 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, multiple inputs high. Expected output1=1", test_num);
            enable = 1;
            input1 = 1; input2 = 0; input3 = 1; input4 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: enable=1, all inputs high. Expected output1=1", test_num);
            enable = 1;
            input1 = 1; input2 = 1; input3 = 1; input4 = 1;
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
