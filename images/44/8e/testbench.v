`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_wbs_adr;
    reg i_wbs_cyc;
    reg [31:0] i_wbs_dat;
    reg [3:0] i_wbs_sel;
    reg i_wbs_stb;
    reg i_wbs_we;
    reg rst;
    wire o_wbs_ack;
    wire [31:0] o_wbs_dat;
    wire o_wbs_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_wbs_adr(i_wbs_adr),
        .i_wbs_cyc(i_wbs_cyc),
        .i_wbs_dat(i_wbs_dat),
        .i_wbs_sel(i_wbs_sel),
        .i_wbs_stb(i_wbs_stb),
        .i_wbs_we(i_wbs_we),
        .rst(rst),
        .o_wbs_ack(o_wbs_ack),
        .o_wbs_dat(o_wbs_dat),
        .o_wbs_int(o_wbs_int)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        i_wbs_adr = 32'h0;
        i_wbs_cyc = 1'b0;
        i_wbs_dat = 32'h0;
        i_wbs_sel = 4'h0;
        i_wbs_stb = 1'b0;
        i_wbs_we  = 1'b0;
        #20;
        rst = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Post-Reset State");
        #1;

        check_outputs(1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        i_wbs_adr = 32'h12345678;
        i_wbs_cyc = 1'b1;
        i_wbs_stb = 1'b1;
        i_wbs_we  = 1'b0;
        i_wbs_sel = 4'hF;

        @(posedge clk);
        #1;
        $display("Testcase 002: Basic Read from 0x12345678");

        #1;


        check_outputs(1'b1, 32'h12345678, 1'b0);


        i_wbs_cyc = 1'b0;
        i_wbs_stb = 1'b0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        i_wbs_adr = 32'hCAFEF00D;
        i_wbs_dat = 32'h87654321;
        i_wbs_cyc = 1'b1;
        i_wbs_stb = 1'b1;
        i_wbs_we  = 1'b1;
        i_wbs_sel = 4'hF;

        @(posedge clk);
        #1;
        $display("Testcase 003: Basic Write to 0xCAFEF00D");

        #1;


        check_outputs(1'b1, o_wbs_dat, 1'b0);

        i_wbs_cyc = 1'b0;
        i_wbs_stb = 1'b0;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge clk);
        i_wbs_adr = 32'hAAAAAAAA;
        i_wbs_cyc = 1'b1;
        i_wbs_stb = 1'b1;
        i_wbs_we  = 1'b0;
        i_wbs_sel = 4'hF;

        @(posedge clk);
        #1;
        $display("Testcase 004: Read from 0xAAAAAAAA");
        #1;

        check_outputs(1'b1, 32'hAAAAAAAA, 1'b0);

        i_wbs_cyc = 1'b0;
        i_wbs_stb = 1'b0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge clk);
        i_wbs_adr = 32'hBBBBBBBB;
        i_wbs_cyc = 1'b1;
        i_wbs_stb = 1'b0;
        i_wbs_we  = 1'b0;

        @(posedge clk);
        #1;
        $display("Testcase 005: Transaction with STB=0");
        #1;

        check_outputs(1'b0, 0, 1'b0);

        i_wbs_cyc = 1'b0;
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
        input expected_o_wbs_ack;
        input [31:0] expected_o_wbs_dat;
        input expected_o_wbs_int;
        begin
            if (expected_o_wbs_ack === (expected_o_wbs_ack ^ o_wbs_ack ^ expected_o_wbs_ack) &&
                expected_o_wbs_dat === (expected_o_wbs_dat ^ o_wbs_dat ^ expected_o_wbs_dat) &&
                expected_o_wbs_int === (expected_o_wbs_int ^ o_wbs_int ^ expected_o_wbs_int)) begin
                $display("PASS");
                $display("  Outputs: o_wbs_ack=%b, o_wbs_dat=%h, o_wbs_int=%b",
                         o_wbs_ack, o_wbs_dat, o_wbs_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wbs_ack=%b, o_wbs_dat=%h, o_wbs_int=%b",
                         expected_o_wbs_ack, expected_o_wbs_dat, expected_o_wbs_int);
                $display("  Got:      o_wbs_ack=%b, o_wbs_dat=%h, o_wbs_int=%b",
                         o_wbs_ack, o_wbs_dat, o_wbs_int);
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
        $dumpvars(0,clk, i_wbs_adr, i_wbs_cyc, i_wbs_dat, i_wbs_sel, i_wbs_stb, i_wbs_we, rst, o_wbs_ack, o_wbs_dat, o_wbs_int);
    end

endmodule
