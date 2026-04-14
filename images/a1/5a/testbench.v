`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock0;
    reg clock180;
    reg countd;
    reg countu;
    reg reset;
    wire [7:0] nr_presses;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock0(clock0),
        .clock180(clock180),
        .countd(countd),
        .countu(countu),
        .reset(reset),
        .nr_presses(nr_presses)
    );

    // Clock generation (10ns period)
    initial begin
        clock0 = 0;
        forever #5 clock0 = ~clock0;
    end

        task reset_dut;

        begin
            reset = 1;
            countu = 0;
            countd = 0;
            @(posedge clock0);
            #1 reset = 0;
            repeat(2) @(posedge clock0);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Increment");
            reset_dut();
            @(posedge clock0);
            countu = 1;
            @(posedge clock0);
            countu = 0;
            repeat(2) @(posedge clock0);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Multiple Increments");
            reset_dut();
            repeat(5) begin
                @(posedge clock0);
                countu = 1;
                @(posedge clock0);
                countu = 0;
            end
            repeat(2) @(posedge clock0);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Increment then Decrement");
            reset_dut();

            repeat(3) begin
                @(posedge clock0);
                countu = 1;
                @(posedge clock0);
                countu = 0;
            end

            @(posedge clock0);
            countd = 1;
            @(posedge clock0);
            countd = 0;
            repeat(2) @(posedge clock0);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Underflow Check");
            reset_dut();
            @(posedge clock0);
            countd = 1;
            @(posedge clock0);
            countd = 0;
            repeat(2) @(posedge clock0);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Simultaneous Increment and Decrement");
            reset_dut();
            @(posedge clock0);
            countu = 1;
            countd = 1;
            @(posedge clock0);
            countu = 0;
            countd = 0;
            repeat(2) @(posedge clock0);


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
        input [7:0] expected_nr_presses;
        begin
            if (expected_nr_presses === (expected_nr_presses ^ nr_presses ^ expected_nr_presses)) begin
                $display("PASS");
                $display("  Outputs: nr_presses=%h",
                         nr_presses);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nr_presses=%h",
                         expected_nr_presses);
                $display("  Got:      nr_presses=%h",
                         nr_presses);
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
        $dumpvars(0,clock0, clock180, countd, countu, reset, nr_presses);
    end

endmodule
