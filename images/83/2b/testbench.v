`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg _cpu_as;
    reg clk;
    reg [22:0] cpu_address;
    reg [22:0] cpu_address_in;
    reg cpu_clk;
    reg cpu_hwr;
    reg cpu_lwr;
    reg cpu_rd;
    reg cpu_rst;
    reg [31:0] cpu_vbr;
    reg dbr;
    reg freeze;
    reg ovl;
    wire aron;
    wire [15:0] cart_data_out;
    wire int7;
    wire ovr;
    wire sel_cart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._cpu_as(_cpu_as),
        .clk(clk),
        .cpu_address(cpu_address),
        .cpu_address_in(cpu_address_in),
        .cpu_clk(cpu_clk),
        .cpu_hwr(cpu_hwr),
        .cpu_lwr(cpu_lwr),
        .cpu_rd(cpu_rd),
        .cpu_rst(cpu_rst),
        .cpu_vbr(cpu_vbr),
        .dbr(dbr),
        .freeze(freeze),
        .ovl(ovl),
        .aron(aron),
        .cart_data_out(cart_data_out),
        .int7(int7),
        .ovr(ovr),
        .sel_cart(sel_cart)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        cpu_rst = 1;
        _cpu_as = 1;
        cpu_address = 0;
        cpu_address_in = 0;
        cpu_rd = 0;
        cpu_hwr = 0;
        cpu_lwr = 0;
        cpu_vbr = 32'h0;
        dbr = 0;
        ovl = 0;
        freeze = 0;
        repeat(5) @(posedge clk);
        cpu_rst = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Initial Reset State");
        reset_dut();

        #1;


        check_outputs(1'b0, 16'hzzzz, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Cartridge Read Access");
        reset_dut();
        @(posedge clk);
        cpu_address = 23'h200000;
        cpu_rd = 1;
        _cpu_as = 0;
        repeat(3) @(posedge clk);

        #1;


        check_outputs(1'b1, 16'h0000, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Overlay Activation");
        reset_dut();
        ovl = 1;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 16'hzzzz, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Cartridge Write Access (HWR)");
        reset_dut();
        cpu_address = 23'h200000;
        cpu_hwr = 1;
        cpu_lwr = 0;
        _cpu_as = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 16'h0000, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Interrupt 7 Generation");
        reset_dut();
        freeze = 1;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b0, 16'hzzzz, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Internal RAM/IO Access");
        reset_dut();
        cpu_address = 23'h000100;
        _cpu_as = 0;
        cpu_rd = 1;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b0, 16'hzzzz, 1'b0, 1'b0, 1'b0);
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
        input expected_aron;
        input [15:0] expected_cart_data_out;
        input expected_int7;
        input expected_ovr;
        input expected_sel_cart;
        begin
            if (expected_aron === (expected_aron ^ aron ^ expected_aron) &&
                expected_cart_data_out === (expected_cart_data_out ^ cart_data_out ^ expected_cart_data_out) &&
                expected_int7 === (expected_int7 ^ int7 ^ expected_int7) &&
                expected_ovr === (expected_ovr ^ ovr ^ expected_ovr) &&
                expected_sel_cart === (expected_sel_cart ^ sel_cart ^ expected_sel_cart)) begin
                $display("PASS");
                $display("  Outputs: aron=%b, cart_data_out=%h, int7=%b, ovr=%b, sel_cart=%b",
                         aron, cart_data_out, int7, ovr, sel_cart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aron=%b, cart_data_out=%h, int7=%b, ovr=%b, sel_cart=%b",
                         expected_aron, expected_cart_data_out, expected_int7, expected_ovr, expected_sel_cart);
                $display("  Got:      aron=%b, cart_data_out=%h, int7=%b, ovr=%b, sel_cart=%b",
                         aron, cart_data_out, int7, ovr, sel_cart);
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
        $dumpvars(0,_cpu_as, clk, cpu_address, cpu_address_in, cpu_clk, cpu_hwr, cpu_lwr, cpu_rd, cpu_rst, cpu_vbr, dbr, freeze, ovl, aron, cart_data_out, int7, ovr, sel_cart);
    end

endmodule
