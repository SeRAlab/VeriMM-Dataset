`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_dout;
    reg [15:0] bt_dout;
    reg [15:0] div_dout;
    reg [15:0] dp_ram_dout;
    reg echo;
    reg [15:0] j1_io_addr;
    reg j1_io_rd;
    reg j1_io_wr;
    reg [15:0] mult_dout;
    reg sys_clk_i;
    reg sys_rst_i;
    reg [15:0] uart_dout;
    reg [15:0] ultra_dout;
    wire [7:0] cs;
    wire [15:0] j1_io_din;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_dout(audio_dout),
        .bt_dout(bt_dout),
        .div_dout(div_dout),
        .dp_ram_dout(dp_ram_dout),
        .echo(echo),
        .j1_io_addr(j1_io_addr),
        .j1_io_rd(j1_io_rd),
        .j1_io_wr(j1_io_wr),
        .mult_dout(mult_dout),
        .sys_clk_i(sys_clk_i),
        .sys_rst_i(sys_rst_i),
        .uart_dout(uart_dout),
        .ultra_dout(ultra_dout),
        .cs(cs),
        .j1_io_din(j1_io_din)
    );
    task testcase001;

        begin
            $display("Testcase 001: Multiplier Select (Addr 0x00xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0000;
            mult_dout = 16'hAAAA;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h01, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Divider Select (Addr 0x01xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0100;
            div_dout = 16'hBBBB;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h02, 16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: UART Select (Addr 0x02xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0200;
            uart_dout = 16'hCCCC;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h04, 16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: DP RAM Select (Addr 0x03xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0300;
            dp_ram_dout = 16'hDDDD;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h08, 16'hDDDD);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bluetooth Select (Addr 0x04xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0400;
            bt_dout = 16'hEEEE;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h10, 16'hEEEE);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Audio Select (Addr 0x05xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0500;
            audio_dout = 16'h1234;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h20, 16'h1234);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Ultrasonic Select (Addr 0x06xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0600;
            ultra_dout = 16'h5678;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h40, 16'h5678);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Echo Select (Addr 0x07xx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0700;
            echo = 1'b1;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h80, 16'h0001);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Invalid Address Range (Addr 0xFFxx)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'hFF00;
            j1_io_rd = 1;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h00, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: No Read Enable (j1_io_rd = 0)");
            sys_rst_i = 1; #20; sys_rst_i = 0;
            j1_io_addr = 16'h0000;
            mult_dout = 16'hAAAA;
            j1_io_rd = 0;
            @(posedge sys_clk_i);
            #2; #1;
 check_outputs(8'h01, 16'h0000);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_cs;
        input [15:0] expected_j1_io_din;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_j1_io_din === (expected_j1_io_din ^ j1_io_din ^ expected_j1_io_din)) begin
                $display("PASS");
                $display("  Outputs: cs=%h, j1_io_din=%h",
                         cs, j1_io_din);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs=%h, j1_io_din=%h",
                         expected_cs, expected_j1_io_din);
                $display("  Got:      cs=%h, j1_io_din=%h",
                         cs, j1_io_din);
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

endmodule
