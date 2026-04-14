`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] data_in;
    reg enable;
    reg [2:0] ra_adrs;
    reg [2:0] rb_adrs;
    reg [2:0] rd_adrs;
    reg wr_en;
    wire [15:0] ra_out;
    wire [15:0] rb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_in(data_in),
        .enable(enable),
        .ra_adrs(ra_adrs),
        .rb_adrs(rb_adrs),
        .rd_adrs(rd_adrs),
        .wr_en(wr_en),
        .ra_out(ra_out),
        .rb_out(rb_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable = 0;
            wr_en = 0;
            rd_adrs = 0;
            ra_adrs = 0;
            rb_adrs = 0;
            data_in = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Writing 0xAAAA to Reg 0 and reading back on both ports", test_num);

            enable = 1;
            wr_en = 1;
            rd_adrs = 3'd0;
            data_in = 16'hAAAA;
            @(posedge clock);
            #1;

            wr_en = 0;
            ra_adrs = 3'd0;
            rb_adrs = 3'd0;
            #2;
            #1;

            check_outputs(16'hAAAA, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Write to Reg 2 and Reg 5, then read simultaneously", test_num);

            enable = 1; wr_en = 1; rd_adrs = 3'd2; data_in = 16'h1234;
            @(posedge clock); #1;

            rd_adrs = 3'd5; data_in = 16'h5678;
            @(posedge clock); #1;

            wr_en = 0;
            ra_adrs = 3'd2;
            rb_adrs = 3'd5;
            #2;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Attempt to write while enable is low", test_num);

            enable = 0;
            wr_en = 1;
            rd_adrs = 3'd3;
            data_in = 16'hFFFF;
            @(posedge clock); #1;

            enable = 1;
            wr_en = 0;
            ra_adrs = 3'd3;
            rb_adrs = 3'd3;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Attempt to write while wr_en is low", test_num);

            enable = 1;
            wr_en = 0;
            rd_adrs = 3'd4;
            data_in = 16'hDEAD;
            @(posedge clock); #1;

            ra_adrs = 3'd4;
            rb_adrs = 3'd4;
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Write to the last register (Reg 7)", test_num);
            enable = 1; wr_en = 1; rd_adrs = 3'd7; data_in = 16'h7777;
            @(posedge clock); #1;
            wr_en = 0; ra_adrs = 3'd7; rb_adrs = 3'd7;
            #2;
            #1;

            check_outputs(16'h7777, 16'h7777);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Fill registers 0-7 with pattern", test_num);
            enable = 1; wr_en = 1;
            for(i=0; i<8; i=i+1) begin
                rd_adrs = i;
                data_in = (16'h1000 * i) + 16'h0ABC;
                @(posedge clock); #1;
            end

            wr_en = 0;
            ra_adrs = 3'd1;
            rb_adrs = 3'd6;
            #2;
            #1;

            check_outputs(16'h1ABC, 16'h6ABC);
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
        input [15:0] expected_ra_out;
        input [15:0] expected_rb_out;
        begin
            if (expected_ra_out === (expected_ra_out ^ ra_out ^ expected_ra_out) &&
                expected_rb_out === (expected_rb_out ^ rb_out ^ expected_rb_out)) begin
                $display("PASS");
                $display("  Outputs: ra_out=%h, rb_out=%h",
                         ra_out, rb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ra_out=%h, rb_out=%h",
                         expected_ra_out, expected_rb_out);
                $display("  Got:      ra_out=%h, rb_out=%h",
                         ra_out, rb_out);
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
        $dumpvars(0,clock, data_in, enable, ra_adrs, rb_adrs, rd_adrs, wr_en, ra_out, rb_out);
    end

endmodule
