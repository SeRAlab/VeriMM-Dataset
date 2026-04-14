`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] keypad_col;
    reg [3:0] keypad_row;
    wire [7:0] keypad_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .keypad_col(keypad_col),
        .keypad_row(keypad_row),
        .keypad_out(keypad_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Testing Row 0, Column 0 (Key 1)", test_num);
        keypad_row = 4'b0001;
        keypad_col = 4'b0001;
        @(posedge clk);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Testing Row 0, Column 3 (Key 4)", test_num);
        keypad_row = 4'b0001;
        keypad_col = 4'b1000;
        @(posedge clk);
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Testing Row 1, Column 1 (Key 6)", test_num);
        keypad_row = 4'b0010;
        keypad_col = 4'b0010;
        @(posedge clk);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Testing Row 2, Column 2 (Key 11)", test_num);
        keypad_row = 4'b0100;
        keypad_col = 4'b0100;
        @(posedge clk);
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Testing Row 3, Column 0 (Key 13)", test_num);
        keypad_row = 4'b1000;
        keypad_col = 4'b0001;
        @(posedge clk);
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Testing Row 3, Column 3 (Key 16)", test_num);
        keypad_row = 4'b1000;
        keypad_col = 4'b1000;
        @(posedge clk);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: No keys pressed", test_num);
        keypad_row = 4'b0000;
        keypad_col = 4'b0000;
        @(posedge clk);
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_keypad_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keypad_out === (expected_keypad_out ^ keypad_out ^ expected_keypad_out)) begin
                $display("PASS");
                $display("  Outputs: keypad_out=%h",
                         keypad_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keypad_out=%h",
                         expected_keypad_out);
                $display("  Got:      keypad_out=%h",
                         keypad_out);
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
