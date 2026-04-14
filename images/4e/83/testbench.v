`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_1;
    reg [1:0] input_2;
    reg [2:0] input_3;
    reg input_4;
    reg [1:0] input_5;
    reg input_6;
    wire output_1;

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
        .input_5(input_5),
        .input_6(input_6),
        .output_1(output_1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: input_1 > 7 (Base Condition False)", test_num);
            input_1 = 4'd8;
            input_2 = 2'd0;
            input_3 = 3'd0;
            input_4 = 1'b0;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: input_1 <= 7, no overrides active", test_num);
            input_1 = 4'd7;
            input_2 = 2'd0;
            input_3 = 3'd0;
            input_4 = 1'b0;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Override 1 Active (input_2 = 1)", test_num);
            input_1 = 4'd4;
            input_2 = 2'd1;
            input_3 = 3'd0;
            input_4 = 1'b0;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Override 1 Active (input_2 = 3)", test_num);
            input_1 = 4'd2;
            input_2 = 2'd3;
            input_3 = 3'd0;
            input_4 = 1'b0;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Override 2 Active (input_3 = 4, input_4 = 1)", test_num);
            input_1 = 4'd0;
            input_2 = 2'd0;
            input_3 = 3'd4;
            input_4 = 1'b1;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Override 2 Active (input_3 = 7, input_4 = 1)", test_num);
            input_1 = 4'd5;
            input_2 = 2'd2;
            input_3 = 3'd7;
            input_4 = 1'b1;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Override 3 Active (input_5 = 2, input_6 = 0)", test_num);
            input_1 = 4'd1;
            input_2 = 2'd0;
            input_3 = 3'd0;
            input_4 = 1'b0;
            input_5 = 2'd2;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary - input_3 = 4, but input_4 = 0 (No override)", test_num);
            input_1 = 4'd3;
            input_2 = 2'd0;
            input_3 = 3'd4;
            input_4 = 1'b0;
            input_5 = 2'd0;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary - input_3 = 3, input_4 = 1 (No override)", test_num);
            input_1 = 4'd6;
            input_2 = 2'd0;
            input_3 = 3'd3;
            input_4 = 1'b1;
            input_5 = 2'd1;
            input_6 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary - input_5 = 2, input_6 = 1 (No override)", test_num);
            input_1 = 4'd4;
            input_2 = 2'd2;
            input_3 = 3'd1;
            input_4 = 1'b1;
            input_5 = 2'd2;
            input_6 = 1'b1;
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
        input expected_output_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_1 === (expected_output_1 ^ output_1 ^ expected_output_1)) begin
                $display("PASS");
                $display("  Outputs: output_1=%b",
                         output_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_1=%b",
                         expected_output_1);
                $display("  Got:      output_1=%b",
                         output_1);
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
