`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] note;
    wire [3:0] note_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .note(note),
        .note_out(note_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Testing Note 1 (C4)", test_num);
        note = 22'd191113;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Testing Note 2 (D4)", test_num);
        note = 22'd170262;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Testing Note 3 (E4)", test_num);
        note = 22'd151654;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Testing Note 4 (F4)", test_num);
        note = 22'd143143;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Testing Note 5 (G4)", test_num);
        note = 22'd127551;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Testing Note 6 (A4)", test_num);
        note = 22'd113636;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Testing Note 7 (B4)", test_num);
        note = 22'd101235;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Testing Default Case (No Match)", test_num);
        note = 22'd500000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Testing Zero Input", test_num);
        note = 22'd0;
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_note_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_note_out === (expected_note_out ^ note_out ^ expected_note_out)) begin
                $display("PASS");
                $display("  Outputs: note_out=%h",
                         note_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: note_out=%h",
                         expected_note_out);
                $display("  Got:      note_out=%h",
                         note_out);
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
