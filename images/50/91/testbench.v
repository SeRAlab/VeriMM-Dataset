`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I_reset;
    reg I_wb_clk;
    reg [7:0] I_wb_dat;
    reg I_wb_stb;
    reg I_wb_we;
    wire [7:0] O_leds;
    wire O_wb_ack;
    wire [7:0] O_wb_dat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_reset(I_reset),
        .I_wb_clk(I_wb_clk),
        .I_wb_dat(I_wb_dat),
        .I_wb_stb(I_wb_stb),
        .I_wb_we(I_wb_we),
        .O_leds(O_leds),
        .O_wb_ack(O_wb_ack),
        .O_wb_dat(O_wb_dat)
    );

    // Clock generation (10ns period)
    initial begin
        I_wb_clk = 0;
        forever #5 I_wb_clk = ~I_wb_clk;
    end

        task reset_dut;

        begin
            I_reset = 1;
            I_wb_dat = 0;
            I_wb_stb = 0;
            I_wb_we = 0;
            repeat(2) @(posedge I_wb_clk);
            #1;
            I_reset = 0;
            repeat(1) @(posedge I_wb_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Write 0x55");
            reset_dut();
            I_wb_dat = 8'h55;
            I_wb_we = 1;
            I_wb_stb = 1;
            @(posedge I_wb_clk);
            #1;
            #1;

            check_outputs(8'h55, 1'b1, 8'h55);
            I_wb_we = 0;
            I_wb_stb = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Basic Write 0xAA");
            reset_dut();
            I_wb_dat = 8'hAA;
            I_wb_we = 1;
            I_wb_stb = 1;
            @(posedge I_wb_clk);
            #1;
            #1;

            check_outputs(8'hAA, 1'b1, 8'hAA);
            I_wb_we = 0;
            I_wb_stb = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Write 0xFF");
            reset_dut();
            I_wb_dat = 8'hFF;
            I_wb_we = 1;
            I_wb_stb = 1;
            @(posedge I_wb_clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1, 8'hFF);
            I_wb_we = 0;
            I_wb_stb = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Strobe Active, WE Inactive");
            reset_dut();
            I_wb_dat = 8'hFF;
            I_wb_we = 0;
            I_wb_stb = 1;
            @(posedge I_wb_clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1, 8'h00);
            I_wb_stb = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: WE Active, Strobe Inactive");
            reset_dut();
            I_wb_dat = 8'hA5;
            I_wb_we = 1;
            I_wb_stb = 0;
            @(posedge I_wb_clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Sequential Writes 0x12 -> 0x34");
            reset_dut();

            I_wb_dat = 8'h12; I_wb_we = 1; I_wb_stb = 1;
            @(posedge I_wb_clk);
            #1;

            I_wb_dat = 8'h34; I_wb_we = 1; I_wb_stb = 1;
            @(posedge I_wb_clk);
            #1;

            #1;


            check_outputs(8'h34, 1'b1, 8'h34);
            I_wb_we = 0;
            I_wb_stb = 0;
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
        input [7:0] expected_O_leds;
        input expected_O_wb_ack;
        input [7:0] expected_O_wb_dat;
        begin
            if (expected_O_leds === (expected_O_leds ^ O_leds ^ expected_O_leds) &&
                expected_O_wb_ack === (expected_O_wb_ack ^ O_wb_ack ^ expected_O_wb_ack) &&
                expected_O_wb_dat === (expected_O_wb_dat ^ O_wb_dat ^ expected_O_wb_dat)) begin
                $display("PASS");
                $display("  Outputs: O_leds=%h, O_wb_ack=%b, O_wb_dat=%h",
                         O_leds, O_wb_ack, O_wb_dat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_leds=%h, O_wb_ack=%b, O_wb_dat=%h",
                         expected_O_leds, expected_O_wb_ack, expected_O_wb_dat);
                $display("  Got:      O_leds=%h, O_wb_ack=%b, O_wb_dat=%h",
                         O_leds, O_wb_ack, O_wb_dat);
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
        $dumpvars(0,I_reset, I_wb_clk, I_wb_dat, I_wb_stb, I_wb_we, O_leds, O_wb_ack, O_wb_dat);
    end

endmodule
