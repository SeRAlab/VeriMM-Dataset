`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cen55;
    reg clk;
    reg [15:0] pcm_in;
    reg rst_n;
    reg [7:0] tl;
    wire [15:0] pcm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cen55(cen55),
        .clk(clk),
        .pcm_in(pcm_in),
        .rst_n(rst_n),
        .tl(tl),
        .pcm_out(pcm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            cen55 = 0;
            tl = 0;
            pcm_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic positive gain");
            reset_dut();
            tl = 8'h0A;
            pcm_in = 16'd500;
            cen55 = 1;
            @(posedge clk);
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic negative gain");
            reset_dut();
            tl = 8'h05;
            pcm_in = -16'd1000;
            cen55 = 1;
            @(posedge clk);
            #1;

            check_outputs(-16'd5000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Zero gain factor");
            reset_dut();
            tl = 8'h00;
            pcm_in = 16'h7FFF;
            cen55 = 1;
            @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Zero PCM input");
            reset_dut();
            tl = 8'hFF;
            pcm_in = 16'd0;
            cen55 = 1;
            @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        reg signed [15:0] prev_val;
        begin
            $display("Testcase 005: Clock Enable (cen55) check");
            reset_dut();

            tl = 8'h02;
            pcm_in = 16'd100;
            cen55 = 1;
            @(posedge clk);
            #1 prev_val = pcm_out;


            tl = 8'h05;
            pcm_in = 16'd200;
            cen55 = 0;
            @(posedge clk);
            #1;

            check_outputs(prev_val);
        end
        endtask

    task testcase006;

        integer full_prod;
        begin
            $display("Testcase 006: Truncation check (Overflow)");
            reset_dut();
            tl = 8'd100;
            pcm_in = 16'd2000;
            cen55 = 1;
            @(posedge clk);

            #1;


            check_outputs(16'h0D40);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Max negative input");
            reset_dut();
            tl = 8'd2;
            pcm_in = -16'd32768;
            cen55 = 1;
            @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Max gain value");
            reset_dut();
            tl = 8'hFF;
            pcm_in = 16'd10;
            cen55 = 1;
            @(posedge clk);
            #1;

            check_outputs(16'd2550);
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
        input [15:0] expected_pcm_out;
        begin
            if (expected_pcm_out === (expected_pcm_out ^ pcm_out ^ expected_pcm_out)) begin
                $display("PASS");
                $display("  Outputs: pcm_out=%h",
                         pcm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcm_out=%h",
                         expected_pcm_out);
                $display("  Got:      pcm_out=%h",
                         pcm_out);
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
        $dumpvars(0,cen55, clk, pcm_in, rst_n, tl, pcm_out);
    end

endmodule
