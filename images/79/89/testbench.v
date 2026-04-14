`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_num;
    wire [7:0] final_output;
    wire output_0;
    wire output_1;
    wire output_2;
    wire output_3;
    wire output_4;
    wire output_5;
    wire output_6;
    wire output_7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_num(input_num),
        .final_output(final_output),
        .output_0(output_0),
        .output_1(output_1),
        .output_2(output_2),
        .output_3(output_3),
        .output_4(output_4),
        .output_5(output_5),
        .output_6(output_6),
        .output_7(output_7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'h00 (All Zeros)", test_num);
            input_num = 8'h00;

            #1;


            check_outputs(8'h00, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'hFF (All Ones)", test_num);
            input_num = 8'hFF;
            #1;

            check_outputs(8'hFF, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'h01 (LSB Only)", test_num);
            input_num = 8'h01;
            #1;

            check_outputs(8'h01, 1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'h80 (MSB Only)", test_num);
            input_num = 8'h80;
            #1;

            check_outputs(8'h80, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'hAA (Alternating 10101010)", test_num);
            input_num = 8'hAA;

            #1;


            check_outputs(8'hAA, 0, 1, 0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'h55 (Alternating 01010101)", test_num);
            input_num = 8'h55;

            #1;


            check_outputs(8'h55, 1, 0, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 8'hC3 (Pattern 11000011)", test_num);
            input_num = 8'hC3;

            #1;


            check_outputs(8'hC3, 1, 1, 0, 0, 0, 0, 1, 1);
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
        input [7:0] expected_final_output;
        input expected_output_0;
        input expected_output_1;
        input expected_output_2;
        input expected_output_3;
        input expected_output_4;
        input expected_output_5;
        input expected_output_6;
        input expected_output_7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_output_0 === (expected_output_0 ^ output_0 ^ expected_output_0) &&
                expected_output_1 === (expected_output_1 ^ output_1 ^ expected_output_1) &&
                expected_output_2 === (expected_output_2 ^ output_2 ^ expected_output_2) &&
                expected_output_3 === (expected_output_3 ^ output_3 ^ expected_output_3) &&
                expected_output_4 === (expected_output_4 ^ output_4 ^ expected_output_4) &&
                expected_output_5 === (expected_output_5 ^ output_5 ^ expected_output_5) &&
                expected_output_6 === (expected_output_6 ^ output_6 ^ expected_output_6) &&
                expected_output_7 === (expected_output_7 ^ output_7 ^ expected_output_7)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, output_0=%b, output_1=%b, output_2=%b, output_3=%b, output_4=%b, output_5=%b, output_6=%b, output_7=%b",
                         final_output, output_0, output_1, output_2, output_3, output_4, output_5, output_6, output_7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, output_0=%b, output_1=%b, output_2=%b, output_3=%b, output_4=%b, output_5=%b, output_6=%b, output_7=%b",
                         expected_final_output, expected_output_0, expected_output_1, expected_output_2, expected_output_3, expected_output_4, expected_output_5, expected_output_6, expected_output_7);
                $display("  Got:      final_output=%h, output_0=%b, output_1=%b, output_2=%b, output_3=%b, output_4=%b, output_5=%b, output_6=%b, output_7=%b",
                         final_output, output_0, output_1, output_2, output_3, output_4, output_5, output_6, output_7);
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
