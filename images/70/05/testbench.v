`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_4bit;
    wire [1:0] output_2bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_4bit(input_4bit),
        .output_2bit(output_2bit)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0000", test_num);
            input_4bit = 4'b0000;
            #1;

            check_outputs(get_expected(4'b0000));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 0001", test_num);
            input_4bit = 4'b0001;
            #1;

            check_outputs(get_expected(4'b0001));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 0010", test_num);
            input_4bit = 4'b0010;
            #1;

            check_outputs(get_expected(4'b0010));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 0011", test_num);
            input_4bit = 4'b0011;
            #1;

            check_outputs(get_expected(4'b0011));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0100", test_num);
            input_4bit = 4'b0100;
            #1;

            check_outputs(get_expected(4'b0100));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 0101", test_num);
            input_4bit = 4'b0101;
            #1;

            check_outputs(get_expected(4'b0101));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 0110", test_num);
            input_4bit = 4'b0110;
            #1;

            check_outputs(get_expected(4'b0110));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 0111", test_num);
            input_4bit = 4'b0111;
            #1;

            check_outputs(get_expected(4'b0111));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 1000", test_num);
            input_4bit = 4'b1000;
            #1;

            check_outputs(get_expected(4'b1000));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 1001", test_num);
            input_4bit = 4'b1001;
            #1;

            check_outputs(get_expected(4'b1001));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 1010", test_num);
            input_4bit = 4'b1010;
            #1;

            check_outputs(get_expected(4'b1010));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 1011", test_num);
            input_4bit = 4'b1011;
            #1;

            check_outputs(get_expected(4'b1011));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 1100", test_num);
            input_4bit = 4'b1100;
            #1;

            check_outputs(get_expected(4'b1100));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 1101", test_num);
            input_4bit = 4'b1101;
            #1;

            check_outputs(get_expected(4'b1101));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 1110", test_num);
            input_4bit = 4'b1110;
            #1;

            check_outputs(get_expected(4'b1110));

            test_num = test_num + 1;
            $display("Testcase %0d: Input 1111", test_num);
            input_4bit = 4'b1111;
            #1;

            check_outputs(get_expected(4'b1111));
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
        input [1:0] expected_output_2bit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_2bit === (expected_output_2bit ^ output_2bit ^ expected_output_2bit)) begin
                $display("PASS");
                $display("  Outputs: output_2bit=%h",
                         output_2bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_2bit=%h",
                         expected_output_2bit);
                $display("  Got:      output_2bit=%h",
                         output_2bit);
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
