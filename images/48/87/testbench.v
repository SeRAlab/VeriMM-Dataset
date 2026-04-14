`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] wb_adr_i;
    reg wb_clk_i;
    reg wb_rst_i;
    reg wb_stb_i;
    reg [31:0] word00;
    reg [31:0] word01;
    reg [31:0] word02;
    reg [31:0] word03;
    reg [31:0] word04;
    reg [31:0] word05;
    reg [31:0] word06;
    reg [31:0] word07;
    reg [31:0] word08;
    reg [31:0] word09;
    reg [31:0] word10;
    reg [31:0] word11;
    reg [31:0] word12;
    reg [31:0] word13;
    reg [31:0] word14;
    reg [31:0] word15;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_adr_i(wb_adr_i),
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_stb_i(wb_stb_i),
        .word00(word00),
        .word01(word01),
        .word02(word02),
        .word03(word03),
        .word04(word04),
        .word05(word05),
        .word06(word06),
        .word07(word07),
        .word08(word08),
        .word09(word09),
        .word10(word10),
        .word11(word11),
        .word12(word12),
        .word13(word13),
        .word14(word14),
        .word15(word15),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            wb_stb_i = 0;
            wb_adr_i = 0;
            word00 = 32'h00000000; word01 = 32'h11111111; word02 = 32'h22222222;
            word03 = 32'h33333333; word04 = 32'h44444444; word05 = 32'h55555555;
            word06 = 32'h66666666; word07 = 32'h77777777; word08 = 32'h88888888;
            word09 = 32'h99999999; word10 = 32'hAAAAAAAA; word11 = 32'hBBBBBBBB;
            word12 = 32'hCCCCCCCC; word13 = 32'hDDDDDDDD; word14 = 32'hEEEEEEEE;
            word15 = 32'hFFFFFFFF;
            @(posedge wb_clk_i);
            #1 wb_rst_i = 0;
            @(posedge wb_clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Read Word 00 at Address 0x0000");
            reset_dut();
            wb_adr_i = 16'h0000;
            wb_stb_i = 1;
            @(posedge wb_clk_i);
            #2;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Read Word 15 at Address 0x000F");
            reset_dut();
            wb_adr_i = 16'h000F;
            wb_stb_i = 1;
            @(posedge wb_clk_i);
            #2;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read with high address bits (0x1234 -> Word 04)");
            reset_dut();
            wb_adr_i = 16'h1234;
            wb_stb_i = 1;
            @(posedge wb_clk_i);
            #2;
            #1;

            check_outputs(1'b1, 32'h44444444);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: No Access (wb_stb_i = 0)");
            reset_dut();
            wb_adr_i = 16'h0005;
            wb_stb_i = 0;
            @(posedge wb_clk_i);
            #2;


            if (wb_ack_o === 0) begin
                $display("PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Ack was high without strobe");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Read Word 08 at Address 0x0008");
            reset_dut();
            wb_adr_i = 16'h0008;
            wb_stb_i = 1;
            @(posedge wb_clk_i);
            #2;
            #1;

            check_outputs(1'b1, 32'h88888888);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Check outputs during reset");
            reset_dut();
            wb_rst_i = 1;
            wb_stb_i = 1;
            wb_adr_i = 16'h0001;
            @(posedge wb_clk_i);
            #2;

            if (wb_ack_o === 0) begin
                $display("PASS: Ack held low during reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Ack was high during reset");
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
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        begin
            if (expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: wb_ack_o=%b, wb_dat_o=%h",
                         wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_ack_o=%b, wb_dat_o=%h",
                         expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      wb_ack_o=%b, wb_dat_o=%h",
                         wb_ack_o, wb_dat_o);
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
        $dumpvars(0,wb_adr_i, wb_clk_i, wb_rst_i, wb_stb_i, word00, word01, word02, word03, word04, word05, word06, word07, word08, word09, word10, word11, word12, word13, word14, word15, wb_ack_o, wb_dat_o);
    end

endmodule
