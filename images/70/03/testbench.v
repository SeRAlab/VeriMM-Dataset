`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [2:0] count;
    wire Tula;
    wire [1:0] Tx;
    wire [1:0] Ty;
    wire [1:0] Tz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .count(count),
        .Tula(Tula),
        .Tx(Tx),
        .Ty(Ty),
        .Tz(Tz)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            count = 3'b111;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            count = 3'd0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 2'b01, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            count = 3'd1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            count = 3'd2;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            count = 3'd3;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 2'b10, 2'b10, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            count = 3'd4;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 2'b11, 2'b11, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            count = 3'd5;
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 2'b00, 2'b00);
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
        input expected_Tula;
        input [1:0] expected_Tx;
        input [1:0] expected_Ty;
        input [1:0] expected_Tz;
        begin
            if (expected_Tula === (expected_Tula ^ Tula ^ expected_Tula) &&
                expected_Tx === (expected_Tx ^ Tx ^ expected_Tx) &&
                expected_Ty === (expected_Ty ^ Ty ^ expected_Ty) &&
                expected_Tz === (expected_Tz ^ Tz ^ expected_Tz)) begin
                $display("PASS");
                $display("  Outputs: Tula=%b, Tx=%h, Ty=%h, Tz=%h",
                         Tula, Tx, Ty, Tz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Tula=%b, Tx=%h, Ty=%h, Tz=%h",
                         expected_Tula, expected_Tx, expected_Ty, expected_Tz);
                $display("  Got:      Tula=%b, Tx=%h, Ty=%h, Tz=%h",
                         Tula, Tx, Ty, Tz);
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
        $dumpvars(0,clock, count, Tula, Tx, Ty, Tz);
    end

endmodule
