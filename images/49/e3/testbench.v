`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Equality", test_num);
            in1 = 16'd0;
            in2 = 16'd0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Equality", test_num);
            in1 = 16'd1234;
            in2 = 16'd1234;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Equality", test_num);
            in1 = -16'd5678;
            in2 = -16'd5678;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Greater Than", test_num);
            in1 = 16'd100;
            in2 = 16'd50;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Less Than", test_num);
            in1 = 16'd50;
            in2 = 16'd100;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Greater Than", test_num);
            in1 = -16'd10;
            in2 = -16'd20;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Less Than", test_num);
            in1 = -16'd20;
            in2 = -16'd10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive vs Negative", test_num);
            in1 = 16'd1;
            in2 = -16'd1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative vs Positive", test_num);
            in1 = -16'd1;
            in2 = 16'd1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Positive vs Max-1", test_num);
            in1 = 16'h7FFF;
            in2 = 16'h7FFE;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Min Negative vs Min+1", test_num);
            in1 = 16'h8000;
            in2 = 16'h8001;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Positive vs Min Negative", test_num);
            in1 = 16'h7FFF;
            in2 = 16'h8000;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Min Negative vs Max Positive", test_num);
            in1 = 16'h8000;
            in2 = 16'h7FFF;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero vs Min Negative", test_num);
            in1 = 16'd0;
            in2 = 16'h8000;
            #1;

            check_outputs(2'b10);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input [1:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
