`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] data_in;
    reg en;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            en <= 1;
            data_in <= 7'h00;
            @(posedge clk);
            en <= 0;
            data_in <= 7'h00;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic load...");
            reset_dut();
            @(posedge clk);
            en <= 1;
            data_in <= 7'h55;
            @(posedge clk);
            en <= 0;
            #1;
            #1;

            check_outputs(7'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Data retention (en=0)...");
            reset_dut();

            @(posedge clk);
            en <= 1;
            data_in <= 7'h2A;
            @(posedge clk);

            en <= 0;
            data_in <= 7'h7F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h2A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load max value 0x7F...");
            reset_dut();
            @(posedge clk);
            en <= 1;
            data_in <= 7'h7F;
            @(posedge clk);
            en <= 0;
            #1;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load zero value...");
            reset_dut();

            @(posedge clk);
            en <= 1;
            data_in <= 7'h7F;
            @(posedge clk);

            en <= 1;
            data_in <= 7'h00;
            @(posedge clk);
            en <= 0;
            #1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Enable signal sensitivity...");
            reset_dut();
            @(posedge clk);
            en <= 1;
            data_in <= 7'h12;
            @(posedge clk);

            data_in <= 7'h34;
            #2;
            en <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h12);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Consecutive writes...");
            reset_dut();
            @(posedge clk);
            en <= 1;
            data_in <= 7'h01;
            @(posedge clk);
            data_in <= 7'h02;
            @(posedge clk);
            data_in <= 7'h04;
            @(posedge clk);
            en <= 0;
            #1;
            #1;

            check_outputs(7'h04);
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
        input [6:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, en, q);
    end

endmodule
