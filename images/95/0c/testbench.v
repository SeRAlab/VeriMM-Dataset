`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg note_done;
    reg play;
    reg reset;
    wire new_note;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .note_done(note_done),
        .play(play),
        .reset(reset),
        .new_note(new_note)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            play = 0;
            note_done = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition RESET -> NEW_NOTE", test_num);
            reset_dut();
            play = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition NEW_NOTE -> WAIT", test_num);
            reset_dut();
            play = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in WAIT when note_done=0", test_num);
            reset_dut();
            play = 1;
            @(posedge clk);
            @(posedge clk);
            note_done = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition WAIT -> NEXT_NOTE -> NEW_NOTE", test_num);
            reset_dut();
            play = 1;
            @(posedge clk);
            @(posedge clk);
            note_done = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Return to RESET when play=0 during WAIT", test_num);
            reset_dut();
            play = 1;
            @(posedge clk);
            @(posedge clk);
            play = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
    endcase


    task testcase006;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify RESET state output", test_num);
            reset_dut();
            play = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rapid toggle of play signal", test_num);
            reset_dut();
            play = 1;
            @(posedge clk);
            play = 0;
            @(posedge clk);
            play = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_new_note;
        begin
            if (expected_new_note === (expected_new_note ^ new_note ^ expected_new_note)) begin
                $display("PASS");
                $display("  Outputs: new_note=%b",
                         new_note);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_note=%b",
                         expected_new_note);
                $display("  Got:      new_note=%b",
                         new_note);
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
        $dumpvars(0,clk, note_done, play, reset, new_note);
    end

endmodule
