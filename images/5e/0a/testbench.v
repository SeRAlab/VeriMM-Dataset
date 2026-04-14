`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg counter_clk;
    reg en;
    reg [6:0] in_x;
    reg [6:0] in_y;
    reg reset;
    wire comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .counter_clk(counter_clk),
        .en(en),
        .in_x(in_x),
        .in_y(in_y),
        .reset(reset),
        .comp(comp)
    );

    // Clock generation (10ns period)
    initial begin
        counter_clk = 0;
        forever #5 counter_clk = ~counter_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            in_x = 0;
            in_y = 0;
            @(posedge counter_clk);
            #2 reset = 0;
            @(posedge counter_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            in_x = 7'h1A;
            in_y = 7'h1A;
            en = 1;
            @(posedge counter_clk);
            #2;
            $display("Testcase 001: Change detected and match found.");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            in_x = 7'h2B;
            in_y = 7'h2B;
            en = 1;
            @(posedge counter_clk);
            #2;

            in_x = 7'h2B;
            in_y = 7'h2B;
            en = 1;
            @(posedge counter_clk);
            #2;
            $display("Testcase 002: Match found but no change in in_x.");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in_x = 7'h3C;
            in_y = 7'h3C;
            en = 0;
            @(posedge counter_clk);
            #2;
            $display("Testcase 003: Match and change, but en is low.");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in_x = 7'h4D;
            in_y = 7'h4E;
            en = 1;
            @(posedge counter_clk);
            #2;
            $display("Testcase 004: Change detected but in_x != in_y.");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            $display("Testcase 005: Output check immediately after reset.");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            in_x = 7'h05; in_y = 7'h05; en = 1;
            @(posedge counter_clk);
            #2;

            in_x = 7'h0A; in_y = 7'h0A; en = 1;
            @(posedge counter_clk);
            #2;
            $display("Testcase 006: Second successive change match.");
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
        input expected_comp;
        begin
            if (expected_comp === (expected_comp ^ comp ^ expected_comp)) begin
                $display("PASS");
                $display("  Outputs: comp=%b",
                         comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp=%b",
                         expected_comp);
                $display("  Got:      comp=%b",
                         comp);
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
        $dumpvars(0,counter_clk, en, in_x, in_y, reset, comp);
    end

endmodule
