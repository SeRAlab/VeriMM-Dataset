`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_val;
    wire [31:0] output_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_val(input_val),
        .output_val(output_val)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input = 0", test_num);
        input_val = 32'sd0;
        #1;

        check_outputs(32'sd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input = 100", test_num);
        input_val = 32'sd100;
        #1;

        check_outputs(32'sd110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input = -1", test_num);
        input_val = -32'sd1;
        #1;

        check_outputs(32'sd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input = -10", test_num);
        input_val = -32'sd10;
        #1;

        check_outputs(32'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input = -50", test_num);
        input_val = -32'sd50;
        #1;

        check_outputs(-32'sd40);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input = Max Positive (0x7FFFFFFF)", test_num);
        input_val = 32'h7FFFFFFF;

        #1;


        check_outputs(32'h80000009);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input = Min Negative (0x80000000)", test_num);
        input_val = 32'h80000000;

        #1;


        check_outputs(32'h8000000A);
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
        input [31:0] expected_output_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_val === (expected_output_val ^ output_val ^ expected_output_val)) begin
                $display("PASS");
                $display("  Outputs: output_val=%h",
                         output_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_val=%h",
                         expected_output_val);
                $display("  Got:      output_val=%h",
                         output_val);
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
