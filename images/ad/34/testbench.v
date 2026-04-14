`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i_RESULT;
    reg [63:0] i_WORD;
    wire [7:0] o_RESULT;
    wire [31:0] o_WORD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_RESULT(i_RESULT),
        .i_WORD(i_WORD),
        .o_RESULT(o_RESULT),
        .o_WORD(o_WORD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High part is zero", test_num);
            i_WORD = 64'h00000000_12345678;
            i_RESULT = 8'h0A;

            #1;


            check_outputs(8'h0A, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High part is non-zero", test_num);
            i_WORD = 64'hABCDEF01_55555555;
            i_RESULT = 8'h01;

            #1;


            check_outputs(8'h41, 32'hABCDEF01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High part non-zero, bit 6 of result already set", test_num);
            i_WORD = 64'h00000001_FFFFFFFF;
            i_RESULT = 8'h45;

            #1;


            check_outputs(8'h45, 32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros input", test_num);
            i_WORD = 64'h00000000_00000000;
            i_RESULT = 8'h00;

            #1;


            check_outputs(8'h00, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High part zero, i_RESULT has bit 6 set", test_num);
            i_WORD = 64'h00000000_FFFFFFFF;
            i_RESULT = 8'hC0;

            #1;


            check_outputs(8'hC0, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High part non-zero (MSB only)", test_num);
            i_WORD = 64'h80000000_00000000;
            i_RESULT = 8'h00;

            #1;


            check_outputs(8'h40, 32'h80000000);
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
        input [7:0] expected_o_RESULT;
        input [31:0] expected_o_WORD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_RESULT === (expected_o_RESULT ^ o_RESULT ^ expected_o_RESULT) &&
                expected_o_WORD === (expected_o_WORD ^ o_WORD ^ expected_o_WORD)) begin
                $display("PASS");
                $display("  Outputs: o_RESULT=%h, o_WORD=%h",
                         o_RESULT, o_WORD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_RESULT=%h, o_WORD=%h",
                         expected_o_RESULT, expected_o_WORD);
                $display("  Got:      o_RESULT=%h, o_WORD=%h",
                         o_RESULT, o_WORD);
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
