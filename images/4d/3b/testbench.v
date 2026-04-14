`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_i;
    reg clk;
    reg lchar;
    reg nchar;
    reg reset;
    reg stb_i;
    wire ack_o;
    wire [8:0] dat_o;
    wire empty_o;
    wire full_o;
    wire [7:0] occupied_tb;
    wire [2:0] rp_tb;
    wire we_tb;
    wire [2:0] wp_tb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .char_i(char_i),
        .clk(clk),
        .lchar(lchar),
        .nchar(nchar),
        .reset(reset),
        .stb_i(stb_i),
        .ack_o(ack_o),
        .dat_o(dat_o),
        .empty_o(empty_o),
        .full_o(full_o),
        .occupied_tb(occupied_tb),
        .rp_tb(rp_tb),
        .we_tb(we_tb),
        .wp_tb(wp_tb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stb_i = 0;
            nchar = 0;
            lchar = 0;
            char_i = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 9'h000, 1'b1, 1'b0, 8'd0, 3'd0, 1'b0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            char_i = 8'hAA;
            nchar = 1;
            @(posedge clk);
            #1;
            nchar = 0;

            #1;


            check_outputs(1'b1, 9'h0AA, 1'b0, 1'b0, 8'd1, 3'd0, 1'b0, 3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            char_i = 8'h11; nchar = 1; @(posedge clk); #1; nchar = 0;

            char_i = 8'h22; lchar = 1; @(posedge clk); #1; lchar = 0;

            #1;


            check_outputs(1'b1, 9'h011, 1'b0, 1'b0, 8'd2, 3'd0, 1'b0, 3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            char_i = 8'h55; nchar = 1; @(posedge clk); #1; nchar = 0;

            char_i = 8'h66; lchar = 1; @(posedge clk); #1; lchar = 0;

            stb_i = 1; @(posedge clk); #1; stb_i = 0;

            #1;


            check_outputs(1'b1, 9'h166, 1'b0, 1'b0, 8'd1, 3'd1, 1'b0, 3'd2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                char_i = i[7:0];
                nchar = 1;
                @(posedge clk);
                #1;
                nchar = 0;
            end

            #1;


            check_outputs(1'b1, 9'h000, 1'b0, 1'b1, 8'd8, 3'd0, 1'b0, 3'd0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();

            for (i = 0; i < 9; i = i + 1) begin
                char_i = i[7:0];
                nchar = 1;
                @(posedge clk);
                #1;
                nchar = 0;
            end

            #1;


            check_outputs(1'b1, 9'h000, 1'b0, 1'b1, 8'd8, 3'd0, 1'b0, 3'd0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                char_i = 8'hFF; nchar = 1; @(posedge clk); #1; nchar = 0;
            end

            for (i = 0; i < 8; i = i + 1) begin
                stb_i = 1; @(posedge clk); #1; stb_i = 0;
            end

            #1;


            check_outputs(1'b0, 9'h000, 1'b1, 1'b0, 8'd0, 3'd0, 1'b0, 3'd0);
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
        input expected_ack_o;
        input [8:0] expected_dat_o;
        input expected_empty_o;
        input expected_full_o;
        input [7:0] expected_occupied_tb;
        input [2:0] expected_rp_tb;
        input expected_we_tb;
        input [2:0] expected_wp_tb;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_empty_o === (expected_empty_o ^ empty_o ^ expected_empty_o) &&
                expected_full_o === (expected_full_o ^ full_o ^ expected_full_o) &&
                expected_occupied_tb === (expected_occupied_tb ^ occupied_tb ^ expected_occupied_tb) &&
                expected_rp_tb === (expected_rp_tb ^ rp_tb ^ expected_rp_tb) &&
                expected_we_tb === (expected_we_tb ^ we_tb ^ expected_we_tb) &&
                expected_wp_tb === (expected_wp_tb ^ wp_tb ^ expected_wp_tb)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, dat_o=%h, empty_o=%b, full_o=%b, occupied_tb=%h, rp_tb=%h, we_tb=%b, wp_tb=%h",
                         ack_o, dat_o, empty_o, full_o, occupied_tb, rp_tb, we_tb, wp_tb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, dat_o=%h, empty_o=%b, full_o=%b, occupied_tb=%h, rp_tb=%h, we_tb=%b, wp_tb=%h",
                         expected_ack_o, expected_dat_o, expected_empty_o, expected_full_o, expected_occupied_tb, expected_rp_tb, expected_we_tb, expected_wp_tb);
                $display("  Got:      ack_o=%b, dat_o=%h, empty_o=%b, full_o=%b, occupied_tb=%h, rp_tb=%h, we_tb=%b, wp_tb=%h",
                         ack_o, dat_o, empty_o, full_o, occupied_tb, rp_tb, we_tb, wp_tb);
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
        $dumpvars(0,char_i, clk, lchar, nchar, reset, stb_i, ack_o, dat_o, empty_o, full_o, occupied_tb, rp_tb, we_tb, wp_tb);
    end

endmodule
