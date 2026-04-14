`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_val;
    wire [2:0] output_val;

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
        $display("Testcase %0d: input_val = 5 (Expected: 7)", test_num);
        input_val = 4'd5;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: input_val = 6 (Expected: 7)", test_num);
        input_val = 4'd6;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: input_val = 0 (Expected: 0)", test_num);
        input_val = 4'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: input_val = 4 (Expected: 4)", test_num);
        input_val = 4'd4;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: input_val = 7 (Expected: 7)", test_num);
        input_val = 4'd7;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: input_val = 8 (Expected: 0)", test_num);
        input_val = 4'd8;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: input_val = 13 (Expected: 5)", test_num);
        input_val = 4'd13;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: input_val = 15 (Expected: 7)", test_num);
        input_val = 4'd15;
        #1;

        check_outputs(3'd7);
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
        input [2:0] expected_output_val;
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
