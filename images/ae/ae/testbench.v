`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [6:0] pressed;
    reg rst_n;
    wire [19:0] note_div;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pressed(pressed),
        .rst_n(rst_n),
        .note_div(note_div)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Idle state (No button)", test_num);
            rst_n = 0;
            pressed = 7'b0000000;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pressing Button 0", test_num);
            rst_n = 0;
            #10 rst_n = 1;
            pressed = 7'b0000001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(20'd191110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pressing Button 3", test_num);
            rst_n = 0;
            #10 rst_n = 1;
            pressed = 7'b0001000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(20'd143184);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pressing Button 6", test_num);
            rst_n = 0;
            #10 rst_n = 1;
            pressed = 7'b1000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(20'd101235);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Buttons (0 and 1) - Priority Check", test_num);
            rst_n = 0;
            #10 rst_n = 1;
            pressed = 7'b0000011;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(20'd191110);
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
        input [19:0] expected_note_div;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_note_div === (expected_note_div ^ note_div ^ expected_note_div)) begin
                $display("PASS");
                $display("  Outputs: note_div=%h",
                         note_div);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: note_div=%h",
                         expected_note_div);
                $display("  Got:      note_div=%h",
                         note_div);
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
