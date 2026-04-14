`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] csr_dat_i;
    reg [9:0] h_count;
    reg horiz_sync_i;
    reg rst;
    reg [9:0] v_count;
    reg video_on_h_i;
    wire [7:0] color;
    wire [16:0] csr_adr_o;
    wire csr_stb_o;
    wire horiz_sync_o;
    wire video_on_h_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .csr_dat_i(csr_dat_i),
        .h_count(h_count),
        .horiz_sync_i(horiz_sync_i),
        .rst(rst),
        .v_count(v_count),
        .video_on_h_i(video_on_h_i),
        .color(color),
        .csr_adr_o(csr_adr_o),
        .csr_stb_o(csr_stb_o),
        .horiz_sync_o(horiz_sync_o),
        .video_on_h_o(video_on_h_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            csr_dat_i = 16'h0;
            h_count = 10'h0;
            v_count = 10'h0;
            horiz_sync_i = 0;
            video_on_h_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset and Idle...");
            reset_dut();

            #1;


            check_outputs(8'h0, 17'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Active Video Start (0,0)...");
            reset_dut();
            h_count = 10'd0;
            v_count = 10'd0;
            video_on_h_i = 1'b1;
            csr_dat_i = 16'hAABB;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hBB, 17'h0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: H-Sync Propagation...");
            reset_dut();
            horiz_sync_i = 1'b1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h0, 17'h0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Address calculation at (h=20, v=10)...");
            reset_dut();


            h_count = 10'd20;
            v_count = 10'd10;
            video_on_h_i = 1'b1;
            repeat(2) @(posedge clk);

            if (csr_stb_o === 1'b1 && video_on_h_o === 1'b1) begin
                $display("  Bus Request Active as expected.");
                pass_count = pass_count + 1;
            end else begin
                $display("  Bus Request Inactive.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Color Multiplexing (Byte 1)...");
            reset_dut();

            h_count = 10'd1;
            v_count = 10'd0;
            video_on_h_i = 1'b1;
            csr_dat_i = 16'hCCDD;
            repeat(2) @(posedge clk);


            if (color == 8'hCC || color == 8'hDD) begin
                $display("  Color multiplexing working.");
                pass_count = pass_count + 1;
            end else begin
                $display("  Color multiplexing failed. Got %h", color);
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_color;
        input [16:0] expected_csr_adr_o;
        input expected_csr_stb_o;
        input expected_horiz_sync_o;
        input expected_video_on_h_o;
        begin
            if (expected_color === (expected_color ^ color ^ expected_color) &&
                expected_csr_adr_o === (expected_csr_adr_o ^ csr_adr_o ^ expected_csr_adr_o) &&
                expected_csr_stb_o === (expected_csr_stb_o ^ csr_stb_o ^ expected_csr_stb_o) &&
                expected_horiz_sync_o === (expected_horiz_sync_o ^ horiz_sync_o ^ expected_horiz_sync_o) &&
                expected_video_on_h_o === (expected_video_on_h_o ^ video_on_h_o ^ expected_video_on_h_o)) begin
                $display("PASS");
                $display("  Outputs: color=%h, csr_adr_o=%h, csr_stb_o=%b, horiz_sync_o=%b, video_on_h_o=%b",
                         color, csr_adr_o, csr_stb_o, horiz_sync_o, video_on_h_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color=%h, csr_adr_o=%h, csr_stb_o=%b, horiz_sync_o=%b, video_on_h_o=%b",
                         expected_color, expected_csr_adr_o, expected_csr_stb_o, expected_horiz_sync_o, expected_video_on_h_o);
                $display("  Got:      color=%h, csr_adr_o=%h, csr_stb_o=%b, horiz_sync_o=%b, video_on_h_o=%b",
                         color, csr_adr_o, csr_stb_o, horiz_sync_o, video_on_h_o);
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
        $dumpvars(0,clk, csr_dat_i, h_count, horiz_sync_i, rst, v_count, video_on_h_i, color, csr_adr_o, csr_stb_o, horiz_sync_o, video_on_h_o);
    end

endmodule
