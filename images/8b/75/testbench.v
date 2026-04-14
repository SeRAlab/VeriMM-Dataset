`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] note;
    wire [31:0] adder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .note(note),
        .adder(adder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            note = 0;

            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase001: Note 0");
            reset_dut();
            test_num = 1;
            note = 7'd0;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(32'h000002B2);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase002: Note 60 (Middle C)");
            reset_dut();
            test_num = 2;
            note = 7'd60;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(32'h00161439);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase003: Note 69 (A4 - 440Hz)");
            reset_dut();
            test_num = 3;
            note = 7'd69;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(32'h002517A4);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase004: Note 100");
            reset_dut();
            test_num = 4;
            note = 7'd100;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(32'h00D9428F);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase005: Note 127");
            reset_dut();
            test_num = 5;
            note = 7'd127;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(32'h0671158B);
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
        input [31:0] expected_adder;
        begin
            if (expected_adder === (expected_adder ^ adder ^ expected_adder)) begin
                $display("PASS");
                $display("  Outputs: adder=%h",
                         adder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder=%h",
                         expected_adder);
                $display("  Got:      adder=%h",
                         adder);
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
        $dumpvars(0,clk, note, adder);
    end

endmodule
