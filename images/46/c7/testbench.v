`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address_i;
    reg clk_i;
    reg [7:0] data_i;
    reg [31:0] parport_i;
    reg readstrobe_i;
    reg rst_i;
    reg writestrobe_i;
    wire [7:0] data_o;
    wire [31:0] parport_o;
    wire parport_readstrobe_o;
    wire parport_writestrobe_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_i(address_i),
        .clk_i(clk_i),
        .data_i(data_i),
        .parport_i(parport_i),
        .readstrobe_i(readstrobe_i),
        .rst_i(rst_i),
        .writestrobe_i(writestrobe_i),
        .data_o(data_o),
        .parport_o(parport_o),
        .parport_readstrobe_o(parport_readstrobe_o),
        .parport_writestrobe_o(parport_writestrobe_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        rst_i = 1;
        address_i = 0;
        data_i = 0;
        parport_i = 0;
        readstrobe_i = 0;
        writestrobe_i = 0;
        @(posedge clk_i);
        #1 rst_i = 0;
        @(posedge clk_i);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Checking Reset State");

        #1;


        check_outputs(8'h00, 32'h00000000, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Full 32-bit Write Operation");


        address_i = 2'b00; data_i = 8'hEF; writestrobe_i = 1; @(posedge clk_i); #1;

        address_i = 2'b01; data_i = 8'hBE; writestrobe_i = 1; @(posedge clk_i); #1;

        address_i = 2'b10; data_i = 8'hAD; writestrobe_i = 1; @(posedge clk_i); #1;

        address_i = 2'b11; data_i = 8'hDE; writestrobe_i = 1; @(posedge clk_i); #1;

        writestrobe_i = 0;

        #1;


        check_outputs(8'h00, 32'hDEADBEEF, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Read Operation from Parallel Port Input");

        parport_i = 32'h12345678;
        address_i = 2'b10;
        readstrobe_i = 1;
        @(posedge clk_i); #1;



        #1;




        check_outputs(8'h34, 32'h00000000, 1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Write Strobe Output Logic");

        address_i = 2'b01;
        data_i = 8'h55;
        writestrobe_i = 1;
        @(posedge clk_i); #1;


        #1;



        check_outputs(8'h00, 32'h00005500, 0, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Read Strobe Output Logic");

        parport_i = 32'hAABBCCDD;
        address_i = 2'b00;
        readstrobe_i = 1;
        @(posedge clk_i); #1;


        #1;



        check_outputs(8'hDD, 32'h00000000, 1, 0);
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
        input [7:0] expected_data_o;
        input [31:0] expected_parport_o;
        input expected_parport_readstrobe_o;
        input expected_parport_writestrobe_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_parport_o === (expected_parport_o ^ parport_o ^ expected_parport_o) &&
                expected_parport_readstrobe_o === (expected_parport_readstrobe_o ^ parport_readstrobe_o ^ expected_parport_readstrobe_o) &&
                expected_parport_writestrobe_o === (expected_parport_writestrobe_o ^ parport_writestrobe_o ^ expected_parport_writestrobe_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, parport_o=%h, parport_readstrobe_o=%b, parport_writestrobe_o=%b",
                         data_o, parport_o, parport_readstrobe_o, parport_writestrobe_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, parport_o=%h, parport_readstrobe_o=%b, parport_writestrobe_o=%b",
                         expected_data_o, expected_parport_o, expected_parport_readstrobe_o, expected_parport_writestrobe_o);
                $display("  Got:      data_o=%h, parport_o=%h, parport_readstrobe_o=%b, parport_writestrobe_o=%b",
                         data_o, parport_o, parport_readstrobe_o, parport_writestrobe_o);
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
        $dumpvars(0,address_i, clk_i, data_i, parport_i, readstrobe_i, rst_i, writestrobe_i, data_o, parport_o, parport_readstrobe_o, parport_writestrobe_o);
    end

endmodule
