`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] live_count;
    reg reset;
    reg step;
    wire age_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .live_count(live_count),
        .reset(reset),
        .step(step),
        .age_out(age_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        step = 0;
        live_count = 0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Birth condition (LC=3)");
        reset_dut();
        live_count = 4'd3;
        step = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Survival condition (LC=2)");
        reset_dut();

        live_count = 4'd3;
        step = 1;
        @(posedge clock);
        #1;

        live_count = 4'd2;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Survival condition (LC=3)");
        reset_dut();

        live_count = 4'd3;
        step = 1;
        @(posedge clock);
        #1;

        live_count = 4'd3;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Death by isolation (LC=1)");
        reset_dut();

        live_count = 4'd3;
        step = 1;
        @(posedge clock);
        #1;

        live_count = 4'd1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Death by isolation (LC=0)");
        reset_dut();

        live_count = 4'd3;
        step = 1;
        @(posedge clock);
        #1;

        live_count = 4'd0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Death by overpopulation (LC=4)");
        reset_dut();

        live_count = 4'd3;
        step = 1;
        @(posedge clock);
        #1;

        live_count = 4'd4;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: No birth (LC=2)");
        reset_dut();
        live_count = 4'd2;
        step = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Step signal disabled");
        reset_dut();
        live_count = 4'd3;
        step = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0);
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
        input expected_age_out;
        begin
            if (expected_age_out === (expected_age_out ^ age_out ^ expected_age_out)) begin
                $display("PASS");
                $display("  Outputs: age_out=%b",
                         age_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: age_out=%b",
                         expected_age_out);
                $display("  Got:      age_out=%b",
                         age_out);
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
        $dumpvars(0,clock, live_count, reset, step, age_out);
    end

endmodule
