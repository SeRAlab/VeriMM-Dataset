`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] word_to_rotate;
    wire [31:0] rotated_word;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .word_to_rotate(word_to_rotate),
        .rotated_word(rotated_word)
    );
    task testcase001;

        begin
            test_num = 1;
            word_to_rotate = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            word_to_rotate = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            word_to_rotate = 32'h12345678;
            #1;

            check_outputs(32'h34567812);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            word_to_rotate = 32'hAABBCCDD;
            #1;

            check_outputs(32'hBBCCDDAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            word_to_rotate = 32'h000000FF;
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            word_to_rotate = 32'hFF000000;
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            word_to_rotate = 32'h00FFFF00;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            word_to_rotate = 32'h80000001;
            #1;

            check_outputs(32'h00000180);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            word_to_rotate = 32'hA5A5A5A5;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            word_to_rotate = 32'hDEADBEEF;
            #1;

            check_outputs(32'hADBEEFDE);
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
        input [31:0] expected_rotated_word;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rotated_word === (expected_rotated_word ^ rotated_word ^ expected_rotated_word)) begin
                $display("PASS");
                $display("  Outputs: rotated_word=%h",
                         rotated_word);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rotated_word=%h",
                         expected_rotated_word);
                $display("  Got:      rotated_word=%h",
                         rotated_word);
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
