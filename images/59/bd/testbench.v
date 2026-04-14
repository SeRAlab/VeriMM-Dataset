`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] branchOffset;
    reg jal;
    reg [11:0] jumpOffset;
    reg [15:0] pcNext;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branchOffset(branchOffset),
        .jal(jal),
        .jumpOffset(jumpOffset),
        .pcNext(pcNext),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: JAL = 1, Positive Jump Offset", test_num);
            jal = 1;
            pcNext = 16'h1000;
            jumpOffset = 12'h004;
            branchOffset = 9'h010;
            #1;

            check_outputs(16'h1004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: JAL = 1, Negative Jump Offset (Sign Extension)", test_num);
            jal = 1;
            pcNext = 16'h1000;
            jumpOffset = 12'hFFC;
            branchOffset = 9'h000;

            #1;


            check_outputs(16'h0FFC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: JAL = 0, Positive Branch Offset", test_num);
            jal = 0;
            pcNext = 16'h2000;
            jumpOffset = 12'hABC;
            branchOffset = 9'h008;
            #1;

            check_outputs(16'h2008);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: JAL = 0, Negative Branch Offset (Sign Extension)", test_num);
            jal = 0;
            pcNext = 16'h2000;
            jumpOffset = 12'h000;
            branchOffset = 9'h1F8;

            #1;


            check_outputs(16'h1FF8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC Wrap-around (Positive)", test_num);
            jal = 1;
            pcNext = 16'hFFFF;
            jumpOffset = 12'h001;
            branchOffset = 9'h000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC Wrap-around (Negative)", test_num);
            jal = 0;
            pcNext = 16'h0000;
            jumpOffset = 12'h000;
            branchOffset = 9'h1FF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive Jump Offset", test_num);
            jal = 1;
            pcNext = 16'h1000;
            jumpOffset = 12'h7FF;
            branchOffset = 9'h000;
            #1;

            check_outputs(16'h17FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Negative Jump Offset", test_num);
            jal = 1;
            pcNext = 16'h1000;
            jumpOffset = 12'h800;
            branchOffset = 9'h000;

            #1;


            check_outputs(16'h0800);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Offset Check", test_num);
            jal = 1;
            pcNext = 16'hABCD;
            jumpOffset = 12'h000;
            branchOffset = 9'h1FF;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Negative Branch Offset", test_num);
            jal = 0;
            pcNext = 16'h0200;
            jumpOffset = 12'h000;
            branchOffset = 9'h100;

            #1;


            check_outputs(16'h0100);
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
        input [15:0] expected_result;
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
