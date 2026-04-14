`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] dataa;
    reg [23:0] datab;
    wire [47:0] result;

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
            test_num = 1;
            $display("Test %0d: Zero Multiplication (0 * 0)", test_num);
            dataa = 24'h000000;
            datab = 24'h000000;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Multiplication by One (0x123456 * 1)", test_num);
            dataa = 24'h123456;
            datab = 24'h000001;
            #1;

            check_outputs(48'h000000123456);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Maximum Values (0xFFFFFF * 0xFFFFFF)", test_num);
            dataa = 24'hFFFFFF;
            datab = 24'hFFFFFF;

            #1;


            check_outputs(48'hFFFFFE000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Power of Two (2^12 * 2^11)", test_num);
            dataa = 24'h001000;
            datab = 24'h000800;
            #1;

            check_outputs(48'h000000800000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Large Arbitrary Numbers (0xABCDEF * 0x123456)", test_num);
            dataa = 24'hABCDEF;
            datab = 24'h123456;

            #1;


            check_outputs(48'h000C36E49E019A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Patterned Bits (0xAAAAAA * 0x555555)", test_num);
            dataa = 24'hAAAAAA;
            datab = 24'h555555;

            #1;


            check_outputs(48'h38E38E0E38E2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Prime-like Numbers (0x7FFFFF * 0x000003)", test_num);
            dataa = 24'h7FFFFF;
            datab = 24'h000003;
            #1;

            check_outputs(48'h0000017FFFFFD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Result approaching 48-bit limit (0xFFFF00 * 0xFFFF00)", test_num);
            dataa = 24'hFFFF00;
            datab = 24'hFFFF00;

            #1;


            check_outputs(48'hFFFE00010000);
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
        input [47:0] expected_result;
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
