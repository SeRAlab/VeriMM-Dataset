`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg count;
    reg enablen;
    reg [3:0] highscore;
    reg load;
    wire [3:0] BCD;
    wire enableNext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .count(count),
        .enablen(enablen),
        .highscore(highscore),
        .load(load),
        .BCD(BCD),
        .enableNext(enableNext)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clear = 1;
            count = 0;
            load = 0;
            enablen = 0;
            highscore = 0;
            @(posedge clock);
            #1 clear = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            highscore = 4'd5;
            load = 1;
            @(posedge clock);
            #1 load = 0;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enablen = 0;
            count = 1;
            @(posedge clock);
            #1 count = 0;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enablen = 0;
            count = 1;
            repeat (3) @(posedge clock);
            #1 count = 0;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            highscore = 4'd9;
            load = 1;
            @(posedge clock);
            #1 load = 0;
            count = 1;
            enablen = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enablen = 1;
            count = 1;
            repeat (2) @(posedge clock);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enablen = 0;
            count = 0;
            repeat (2) @(posedge clock);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            highscore = 4'd7;
            load = 1;
            count = 1;
            enablen = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            enablen = 0;
            count = 1;
            repeat (9) @(posedge clock);
            #1;


            @(posedge clock);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            highscore = 4'd8;
            load = 1;
            @(posedge clock);
            #1 load = 0;
            clear = 1;
            @(posedge clock);
            #1 clear = 0;
            #1;

            check_outputs(4'd0, 1'b0);
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
        input [3:0] expected_BCD;
        input expected_enableNext;
        begin
            if (expected_BCD === (expected_BCD ^ BCD ^ expected_BCD) &&
                expected_enableNext === (expected_enableNext ^ enableNext ^ expected_enableNext)) begin
                $display("PASS");
                $display("  Outputs: BCD=%h, enableNext=%b",
                         BCD, enableNext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD=%h, enableNext=%b",
                         expected_BCD, expected_enableNext);
                $display("  Got:      BCD=%h, enableNext=%b",
                         BCD, enableNext);
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
        $dumpvars(0,clear, clock, count, enablen, highscore, load, BCD, enableNext);
    end

endmodule
