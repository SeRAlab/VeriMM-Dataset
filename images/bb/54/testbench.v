`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_num;
    wire [3:0] output_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_num(input_num),
        .output_num(output_num)
    );
    task testcase001;

    begin
        test_num = 1;
        input_num = 4'd0;
        $display("Test %0d: input_num = %d", test_num, input_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input_num = 4'd4;
        $display("Test %0d: input_num = %d", test_num, input_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input_num = 4'd5;
        $display("Test %0d: input_num = %d", test_num, input_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input_num = 4'd6;
        $display("Test %0d: input_num = %d", test_num, input_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input_num = 4'd10;
        $display("Test %0d: input_num = %d", test_num, input_num);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input_num = 4'd15;
        $display("Test %0d: input_num = %d", test_num, input_num);
        #1;

        check_outputs(4'd10);
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
        input [3:0] expected_output_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_num === (expected_output_num ^ output_num ^ expected_output_num)) begin
                $display("PASS");
                $display("  Outputs: output_num=%h",
                         output_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_num=%h",
                         expected_output_num);
                $display("  Got:      output_num=%h",
                         output_num);
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
