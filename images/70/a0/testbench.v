`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] adr_i;
    reg clk_i;
    reg cyc_i;
    reg [31:0] dat_i;
    reg rst_i;
    reg rx;
    reg stb_i;
    reg tx;
    reg we_i;
    wire ack_o;
    wire [31:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .cyc_i(cyc_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .rx(rx),
        .stb_i(stb_i),
        .tx(tx),
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
        adr_i = 0;
        cyc_i = 0;
        stb_i = 0;
        we_i = 0;
        dat_i = 0;
        tx = 0;
        rx = 0;
        gpio_drive = 32'bz;
        #20;
        rst_i = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Initial State Check");
        bus_read(5'h00);
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Register Write/Read Back");
        bus_write(5'h04, 32'hA5A5B6B6);
        bus_read(5'h04);
        #1;

        check_outputs(1'b1, 32'hA5A5B6B6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: TX/RX State Logic Selection");

        bus_write(5'h00, 32'h11111111);
        bus_write(5'h04, 32'h22222222);
        bus_write(5'h08, 32'h33333333);
        bus_write(5'h0C, 32'h44444444);


        tx = 1; rx = 1;
        #10;
        bus_read(5'h00);


        #1;



        check_outputs(1'b1, 32'h44444444);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Wishbone Handshake Verification");
        @(posedge clk_i);
        adr_i = 5'h10;
        dat_i = 32'hCAFEF00D;
        we_i = 1;
        cyc_i = 1;
        stb_i = 1;
        #2;
        if (ack_o === 0) begin

             wait(ack_o);
        end
        #1;

        check_outputs(1'b1, dat_o);
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
        input [31:0] expected_dat_o;
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
        $dumpvars(0,adr_i, clk_i, cyc_i, dat_i, rst_i, rx, stb_i, tx, we_i, ack_o, dat_o);
    end

endmodule
