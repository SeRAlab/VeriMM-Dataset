`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dataa;
    reg [31:0] datab;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            dataa = 32'd10;
            datab = 32'd20;
            $display("Testcase %0d: Simple Positive Multiplications (10 * 20)", test_num);
            #1;

            check_outputs(64'd200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            dataa = 32'd0;
            datab = 32'h12345678;
            $display("Testcase %0d: Zero Multiplication (0 * X)", test_num);
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            dataa = 32'd5;
            datab = -32'd10;
            $display("Testcase %0d: Positive * Negative (5 * -10)", test_num);
            #1;

            check_outputs(-64'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            dataa = -32'd15;
            datab = 32'd4;
            $display("Testcase %0d: Negative * Positive (-15 * 4)", test_num);
            #1;

            check_outputs(-64'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            dataa = -32'd8;
            datab = -32'd7;
            $display("Testcase %0d: Negative * Negative (-8 * -7)", test_num);
            #1;

            check_outputs(64'd56);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            dataa = 32'h7FFFFFFF;
            datab = 32'd1;
            $display("Testcase %0d: Max Positive * 1", test_num);
            #1;

            check_outputs(64'h000000007FFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            dataa = 32'h80000000;
            datab = 32'd1;
            $display("Testcase %0d: Min Negative * 1", test_num);
            #1;

            check_outputs(64'hFFFFFFFF80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            dataa = 32'h7FFFFFFF;
            datab = 32'h7FFFFFFF;
            $display("Testcase %0d: Max Positive Squared", test_num);

            #1;


            check_outputs(64'h3FFFFFFF00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            dataa = 32'h80000000;
            datab = 32'h80000000;
            $display("Testcase %0d: Min Negative Squared", test_num);

            #1;


            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            dataa = 32'h80000000;
            datab = 32'h7FFFFFFF;
            $display("Testcase %0d: Min Negative * Max Positive", test_num);

            #1;


            check_outputs(64'hC000000080000000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            dataa = -32'd1;
            datab = -32'd1;
            $display("Testcase %0d: -1 * -1", test_num);
            #1;

            check_outputs(64'd1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            dataa = 32'hFFFFFFFF;
            datab = 32'd500;
            $display("Testcase %0d: -1 * 500", test_num);
            #1;

            check_outputs(-64'd500);
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
        input [63:0] expected_result;
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
