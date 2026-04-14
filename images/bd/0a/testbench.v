`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] decenas1;
    reg [3:0] decenas2;
    reg [3:0] unidades1;
    reg [3:0] unidades2;
    wire [3:0] an;
    wire [6:0] salidas;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .decenas1(decenas1),
        .decenas2(decenas2),
        .unidades1(unidades1),
        .unidades2(unidades2),
        .an(an),
        .salidas(salidas)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            unidades1 = 0;
            decenas1 = 0;
            unidades2 = 0;
            decenas2 = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Unidades 1...");
            reset_dut();
            unidades1 = 4'd1; decenas1 = 4'd2; unidades2 = 4'd3; decenas2 = 4'd4;

            wait(an == 4'b1110);
            #1;
            #1;

            check_outputs(4'b1110, get_seg(4'd1));
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Decenas 1...");
            reset_dut();
            unidades1 = 4'd1; decenas1 = 4'd2; unidades2 = 4'd3; decenas2 = 4'd4;
            wait(an == 4'b1101);
            #1;
            #1;

            check_outputs(4'b1101, get_seg(4'd2));
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking Unidades 2...");
            reset_dut();
            unidades1 = 4'd5; decenas1 = 4'd6; unidades2 = 4'd7; decenas2 = 4'd8;
            wait(an == 4'b1011);
            #1;
            #1;

            check_outputs(4'b1011, get_seg(4'd7));
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking Decenas 2...");
            reset_dut();
            unidades1 = 4'd5; decenas1 = 4'd6; unidades2 = 4'd7; decenas2 = 4'd8;
            wait(an == 4'b0111);
            #1;
            #1;

            check_outputs(4'b0111, get_seg(4'd8));
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking All Zeros...");
            reset_dut();
            unidades1 = 4'd0; decenas1 = 4'd0; unidades2 = 4'd0; decenas2 = 4'd0;
            wait(an == 4'b1110);
            #1;
            #1;

            check_outputs(4'b1110, get_seg(4'd0));
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking Digit Value 9...");
            reset_dut();
            unidades1 = 4'd9; decenas1 = 4'd9; unidades2 = 4'd9; decenas2 = 4'd9;
            wait(an == 4'b1101);
            #1;
            #1;

            check_outputs(4'b1101, get_seg(4'd9));
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
        input [3:0] expected_an;
        input [6:0] expected_salidas;
        begin
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_salidas === (expected_salidas ^ salidas ^ expected_salidas)) begin
                $display("PASS");
                $display("  Outputs: an=%h, salidas=%h",
                         an, salidas);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, salidas=%h",
                         expected_an, expected_salidas);
                $display("  Got:      an=%h, salidas=%h",
                         an, salidas);
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
        $dumpvars(0,clk, decenas1, decenas2, unidades1, unidades2, an, salidas);
    end

endmodule
