`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] note;
    reg note_off;
    reg note_on;
    reg rst;
    wire out_gate;
    wire [6:0] out_note;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .note(note),
        .note_off(note_off),
        .note_on(note_on),
        .rst(rst),
        .out_gate(out_gate),
        .out_note(out_note)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            note = 0;
            note_on = 0;
            note_off = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Activate single note 60", test_num);
            note = 7'd60;
            note_on = 1;
            @(posedge clk);
            #1 note_on = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 7'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Activate notes 40, 80, 60. Expect 80", test_num);
            note = 7'd40; note_on = 1; @(posedge clk); #1;
            note = 7'd80; note_on = 1; @(posedge clk); #1;
            note = 7'd60; note_on = 1; @(posedge clk); #1;
            note_on = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 7'd80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Activate 50 and 70, then release 70. Expect 50", test_num);
            note = 7'd50; note_on = 1; @(posedge clk); #1;
            note = 7'd70; note_on = 1; @(posedge clk); #1;
            note_on = 0;
            note = 7'd70; note_off = 1; @(posedge clk); #1;
            note_off = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 7'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Activate and release note 100. Expect gate 0", test_num);
            note = 7'd100; note_on = 1; @(posedge clk); #1;
            note_on = 0;
            note = 7'd100; note_off = 1; @(posedge clk); #1;
            note_off = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 7'dx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: Boundary notes 0 and 127. Expect 127", test_num);
            note = 7'd0; note_on = 1; @(posedge clk); #1;
            note = 7'd127; note_on = 1; @(posedge clk); #1;
            note_on = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 7'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case %0d: Notes 10, 20, 30 active. Release 20. Expect 30", test_num);
            note = 7'd10; note_on = 1; @(posedge clk); #1;
            note = 7'd20; note_on = 1; @(posedge clk); #1;
            note = 7'd30; note_on = 1; @(posedge clk); #1;
            note_on = 0;
            note = 7'd20; note_off = 1; @(posedge clk); #1;
            note_off = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 7'd30);
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
        input expected_out_gate;
        input [6:0] expected_out_note;
        begin
            if (expected_out_gate === (expected_out_gate ^ out_gate ^ expected_out_gate) &&
                expected_out_note === (expected_out_note ^ out_note ^ expected_out_note)) begin
                $display("PASS");
                $display("  Outputs: out_gate=%b, out_note=%h",
                         out_gate, out_note);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_gate=%b, out_note=%h",
                         expected_out_gate, expected_out_note);
                $display("  Got:      out_gate=%b, out_note=%h",
                         out_gate, out_note);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, note, note_off, note_on, rst, out_gate, out_note);
    end

endmodule
