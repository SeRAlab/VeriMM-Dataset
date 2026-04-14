`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] word_in;
    wire [31:0] word_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .word_in(word_in),
        .word_out(word_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: General Pattern 0x12345678", test_num);
            word_in = 32'h12345678;
            #1;

            check_outputs(32'h78123456);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            word_in = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            word_in = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB only (0x000000FF)", test_num);
            word_in = 32'h000000FF;
            #1;

            check_outputs(32'hFF000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB only (0xFF000000)", test_num);
            word_in = 32'hFF000000;
            #1;

            check_outputs(32'h00FF0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Internal Byte (0x00FF0000)", test_num);
            word_in = 32'h00FF0000;
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Internal Byte (0x0000FF00)", test_num);
            word_in = 32'h0000FF00;
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DEADBEEF", test_num);
            word_in = 32'hDEADBEEF;
            #1;

            check_outputs(32'hEFDEADBE);
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
        input [31:0] expected_word_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_word_out === (expected_word_out ^ word_out ^ expected_word_out)) begin
                $display("PASS");
                $display("  Outputs: word_out=%h",
                         word_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: word_out=%h",
                         expected_word_out);
                $display("  Got:      word_out=%h",
                         word_out);
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
