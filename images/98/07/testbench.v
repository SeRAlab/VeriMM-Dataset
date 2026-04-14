`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_1;
    reg [7:0] input_2;
    wire output_1;
    wire output_2;
    wire output_3;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .output_1(output_1),
        .output_2(output_2),
        .output_3(output_3),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Equal inputs (0)", test_num);
        input_1 = 8'h00;
        input_2 = 8'h00;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Equal inputs (255)", test_num);
        input_1 = 8'hFF;
        input_2 = 8'hFF;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: input_1 > input_2", test_num);
        input_1 = 8'h0A;
        input_2 = 8'h05;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: input_1 < input_2", test_num);
        input_1 = 8'h20;
        input_2 = 8'h40;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Boundary Max > Min", test_num);
        input_1 = 8'hFF;
        input_2 = 8'h00;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Boundary Min < Max", test_num);
        input_1 = 8'h00;
        input_2 = 8'hFF;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Difference of 1 (Greater)", test_num);
        input_1 = 8'h80;
        input_2 = 8'h7F;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Difference of 1 (Lesser)", test_num);
        input_1 = 8'h7F;
        input_2 = 8'h80;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 8'h00);
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
        input expected_output_1;
        input expected_output_2;
        input expected_output_3;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_1 === (expected_output_1 ^ output_1 ^ expected_output_1) &&
                expected_output_2 === (expected_output_2 ^ output_2 ^ expected_output_2) &&
                expected_output_3 === (expected_output_3 ^ output_3 ^ expected_output_3) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: output_1=%b, output_2=%b, output_3=%b, result=%h",
                         output_1, output_2, output_3, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_1=%b, output_2=%b, output_3=%b, result=%h",
                         expected_output_1, expected_output_2, expected_output_3, expected_result);
                $display("  Got:      output_1=%b, output_2=%b, output_3=%b, result=%h",
                         output_1, output_2, output_3, result);
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
