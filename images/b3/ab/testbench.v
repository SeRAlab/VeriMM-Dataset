`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input1;
    reg [7:0] input10;
    reg input2;
    reg [3:0] input3;
    reg [3:0] input4;
    reg [7:0] input5;
    reg [7:0] input6;
    reg [7:0] input7;
    reg [7:0] input8;
    reg [7:0] input9;
    wire [15:0] output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input10(input10),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .input5(input5),
        .input6(input6),
        .input7(input7),
        .input8(input8),
        .input9(input9),
        .output1(output1)
    );
    task init_inputs;

        begin
            input1 = 0; input2 = 0;
            input3 = 0; input4 = 0;
            input5 = 0; input6 = 0;
            input7 = 0; input8 = 0;
            input9 = 0; input10 = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            init_inputs();
            expected_val = 16'h0000;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Conditional Logic (input2=1, input1=1)", test_num);
            init_inputs();
            input1 = 1;
            input2 = 1;

            expected_val = 16'h0001;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Arithmetic Sum (input3 + input4)", test_num);
            init_inputs();
            input3 = 4'd15;
            input4 = 4'd15;

            expected_val = 16'd30;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Concatenation (input9 and input10 influence)", test_num);
            init_inputs();
            input9 = 8'h12;
            input10 = 8'h34;

            expected_val = 16'h1234;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Combined Logic (Sum + Condition + Concat)", test_num);
            init_inputs();
            input1 = 1;
            input2 = 1;
            input3 = 4'd10;
            input4 = 4'd5;
            input9 = 8'hA0;
            input10 = 8'h0F;

            expected_val = 16'hA01F;
            #1;

            check_outputs(expected_val);
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
        input [15:0] expected_output1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%h",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h",
                         expected_output1);
                $display("  Got:      output1=%h",
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
