`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] fetch_addr;
    reg fetch_rd_en;
    reg [38:0] fetch_tag;
    reg rst;
    wire fetchwave_ack;
    wire [31:0] wave_instr;
    wire [38:0] wave_tag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fetch_addr(fetch_addr),
        .fetch_rd_en(fetch_rd_en),
        .fetch_tag(fetch_tag),
        .rst(rst),
        .fetchwave_ack(fetchwave_ack),
        .wave_instr(wave_instr),
        .wave_tag(wave_tag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            fetch_rd_en = 0;
            fetch_addr = 32'h0;
            fetch_tag = 39'h0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            fetch_rd_en = 1;
            fetch_addr = 32'hCAFE_BABE;
            fetch_tag = 39'h07_FEED_FACE;

            @(posedge clk);
            fetch_rd_en = 0;
            fetch_addr = 32'h0;
            fetch_tag = 39'h0;


            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'hCAFE_BABE, 39'h07_FEED_FACE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            fetch_rd_en = 0;
            fetch_addr = 32'hFFFF_FFFF;
            fetch_tag = 39'h7F_FFFF_FFFF;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'h0, 39'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            fetch_rd_en = 1;
            fetch_addr = 32'h1111_2222;
            fetch_tag = 39'h1A_AAAAAAAA;


            @(posedge clk);
            fetch_rd_en = 1;
            fetch_addr = 32'h3333_4444;
            fetch_tag = 39'h2B_BBBBBBBB;

            @(posedge clk);
            fetch_rd_en = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h3333_4444, 39'h2B_BBBBBBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clk);
            fetch_rd_en = 1;
            fetch_addr = 32'h0000_0000;
            fetch_tag = 39'h00_0000_0000;

            @(posedge clk);
            fetch_rd_en = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h0000_0000, 39'h00_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clk);
            fetch_rd_en = 1;
            fetch_addr = 32'hDEAD_BEEF;
            fetch_tag = 39'h3F_FFFF_FFFF;

            @(posedge clk);
            rst = 1;

            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 32'h0, 39'h0);
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
        input expected_fetchwave_ack;
        input [31:0] expected_wave_instr;
        input [38:0] expected_wave_tag;
        begin
            if (expected_fetchwave_ack === (expected_fetchwave_ack ^ fetchwave_ack ^ expected_fetchwave_ack) &&
                expected_wave_instr === (expected_wave_instr ^ wave_instr ^ expected_wave_instr) &&
                expected_wave_tag === (expected_wave_tag ^ wave_tag ^ expected_wave_tag)) begin
                $display("PASS");
                $display("  Outputs: fetchwave_ack=%b, wave_instr=%h, wave_tag=%h",
                         fetchwave_ack, wave_instr, wave_tag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fetchwave_ack=%b, wave_instr=%h, wave_tag=%h",
                         expected_fetchwave_ack, expected_wave_instr, expected_wave_tag);
                $display("  Got:      fetchwave_ack=%b, wave_instr=%h, wave_tag=%h",
                         fetchwave_ack, wave_instr, wave_tag);
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
        $dumpvars(0,clk, fetch_addr, fetch_rd_en, fetch_tag, rst, fetchwave_ack, wave_instr, wave_tag);
    end

endmodule
