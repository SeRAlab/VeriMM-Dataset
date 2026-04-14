`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] word_i;
    wire [15:0] word_select_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .word_i(word_i),
        .word_select_o(word_select_o)
    );
    task testcase001;

    begin
        test_num = 1;
        word_i = 4'd0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        word_i = 4'd2;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        word_i = 4'd4;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        word_i = 4'd6;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        word_i = 4'd8;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        word_i = 4'd10;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        word_i = 4'd12;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        word_i = 4'd14;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        word_i = 4'd1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        word_i = 4'd7;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        word_i = 4'd15;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_word_select_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_word_select_o === (expected_word_select_o ^ word_select_o ^ expected_word_select_o)) begin
                $display("PASS");
                $display("  Outputs: word_select_o=%h",
                         word_select_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: word_select_o=%h",
                         expected_word_select_o);
                $display("  Got:      word_select_o=%h",
                         word_select_o);
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
