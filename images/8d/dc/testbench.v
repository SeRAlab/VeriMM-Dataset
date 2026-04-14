`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg select;
    wire [3:0] c;
    wire [3:0] ena;
    wire [7:0] f;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .c(c),
        .ena(ena),
        .f(f),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] initial_d;
        begin
            @(posedge clk);
            #1;
            reset = 1;
            d = initial_d;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut(8'hFF);
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 4'h1, 8'h2A, 8'h7F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut(8'hFF);
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 4'h1, 8'hAB, 8'hFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut(8'hF0);
            select = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4, 4'h1, 8'h0F, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut(8'h0F);
            select = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h4, 4'h1, 8'hF0, 8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut(8'hAA);
            select = 0;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h1, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut(8'h55);
            select = 1; @(posedge clk);
            select = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2, 4'h1, 8'hFF, 8'h55);
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
        input [3:0] expected_c;
        input [3:0] expected_ena;
        input [7:0] expected_f;
        input [7:0] expected_q;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_ena === (expected_ena ^ ena ^ expected_ena) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: c=%h, ena=%h, f=%h, q=%h",
                         c, ena, f, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, ena=%h, f=%h, q=%h",
                         expected_c, expected_ena, expected_f, expected_q);
                $display("  Got:      c=%h, ena=%h, f=%h, q=%h",
                         c, ena, f, q);
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
        $dumpvars(0,clk, d, reset, select, c, ena, f, q);
    end

endmodule
