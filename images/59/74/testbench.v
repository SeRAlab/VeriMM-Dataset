`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] adr_i;
    reg [31:0] atr;
    reg clk_i;
    reg cyc_i;
    reg [15:0] dat_i;
    reg [31:0] debug_0;
    reg [31:0] debug_1;
    reg rst_i;
    reg stb_i;
    reg we_i;
    wire ack_o;
    wire [15:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .atr(atr),
        .clk_i(clk_i),
        .cyc_i(cyc_i),
        .dat_i(dat_i),
        .debug_0(debug_0),
        .debug_1(debug_1),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .we_i(we_i),
        .ack_o(ack_o),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            cyc_i = 0;
            stb_i = 0;
            we_i = 0;
            adr_i = 0;
            dat_i = 0;
            atr = 32'h0;
            debug_0 = 32'h0;
            debug_1 = 32'h0;
            #100;
            @(posedge clk_i);
            rst_i = 0;
            #20;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            atr = 32'hA5A5_1234;
            @(posedge clk_i);

            adr_i = 4'd4;
            we_i = 1'b0;
            cyc_i = 1'b1;
            stb_i = 1'b1;

            while (!ack_o) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'h1234);

            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            atr = 32'hA5A5_1234;
            @(posedge clk_i);

            adr_i = 4'd5;
            we_i = 1'b0;
            cyc_i = 1'b1;
            stb_i = 1'b1;

            while (!ack_o) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'hA5A5);

            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            debug_0 = 32'hDEAD_BEEF;
            @(posedge clk_i);

            adr_i = 4'd6;
            we_i = 1'b0;
            cyc_i = 1'b1;
            stb_i = 1'b1;

            while (!ack_o) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'hBEEF);

            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            debug_1 = 32'hCAFE_BABE;
            @(posedge clk_i);

            adr_i = 4'd9;
            we_i = 1'b0;
            cyc_i = 1'b1;
            stb_i = 1'b1;

            while (!ack_o) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'hCAFE);

            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk_i);

            adr_i = 4'd0;
            dat_i = 16'h55AA;
            we_i = 1'b1;
            cyc_i = 1'b1;
            stb_i = 1'b1;

            while (!ack_o) @(posedge clk_i);
            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
            we_i = 1'b0;

            #20;


            cyc_i = 1'b1;
            stb_i = 1'b1;
            while (!ack_o) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'h55AA);

            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk_i);

            adr_i = 4'd2;
            dat_i = 16'hF0F0;
            we_i = 1'b1;
            cyc_i = 1'b1;
            stb_i = 1'b1;

            while (!ack_o) @(posedge clk_i);
            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
            we_i = 1'b0;

            #20;


            cyc_i = 1'b1;
            stb_i = 1'b1;
            while (!ack_o) @(posedge clk_i);
            #1;
            #1;

            check_outputs(1'b1, 16'hF0F0);

            @(posedge clk_i);
            cyc_i = 1'b0;
            stb_i = 1'b0;
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
        input expected_ack_o;
        input [15:0] expected_dat_o;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, dat_o=%h",
                         ack_o, dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, dat_o=%h",
                         expected_ack_o, expected_dat_o);
                $display("  Got:      ack_o=%b, dat_o=%h",
                         ack_o, dat_o);
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
        $dumpvars(0,adr_i, atr, clk_i, cyc_i, dat_i, debug_0, debug_1, rst_i, stb_i, we_i, ack_o, dat_o);
    end

endmodule
