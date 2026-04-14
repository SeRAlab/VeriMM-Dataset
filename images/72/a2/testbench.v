`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg write_enable;
    wire [15:0] data_out;
    wire [15:0] sram_addr;
    wire sram_ce_n;
    wire sram_oe_n;
    wire sram_we_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .write_enable(write_enable),
        .data_out(data_out),
        .sram_addr(sram_addr),
        .sram_ce_n(sram_ce_n),
        .sram_oe_n(sram_oe_n),
        .sram_we_n(sram_we_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_enable = 0;
            address = 0;
            data_in = 0;
            sram_dq_drive_reg = 16'hzzzz;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            write_enable = 0;
            address = 16'hAAAA;
            data_in = 16'h5555;
            @(posedge clk);

            #1;


            check_outputs(16'h0, 16'h0, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            write_enable = 1;
            address = 16'h1234;
            data_in = 16'hABCD;
            @(posedge clk);

            #1;


            check_outputs(16'h0, 16'h1234, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            write_enable = 0;
            address = 16'h55AA;
            sram_dq_drive_reg = 16'hBEEF;
            @(posedge clk);

            #1;


            check_outputs(16'hBEEF, 16'h55AA, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            write_enable = 1;
            address = 16'h1001;
            data_in = 16'hCAFE;
            @(posedge clk);


            #1;
            write_enable = 0;
            address = 16'h2002;
            sram_dq_drive_reg = 16'hFACE;
            @(posedge clk);


            #1;



            check_outputs(16'hFACE, 16'h2002, 0, 0, 1);
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
        input [15:0] expected_data_out;
        input [15:0] expected_sram_addr;
        input expected_sram_ce_n;
        input expected_sram_oe_n;
        input expected_sram_we_n;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_sram_addr === (expected_sram_addr ^ sram_addr ^ expected_sram_addr) &&
                expected_sram_ce_n === (expected_sram_ce_n ^ sram_ce_n ^ expected_sram_ce_n) &&
                expected_sram_oe_n === (expected_sram_oe_n ^ sram_oe_n ^ expected_sram_oe_n) &&
                expected_sram_we_n === (expected_sram_we_n ^ sram_we_n ^ expected_sram_we_n)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, sram_addr=%h, sram_ce_n=%b, sram_oe_n=%b, sram_we_n=%b",
                         data_out, sram_addr, sram_ce_n, sram_oe_n, sram_we_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, sram_addr=%h, sram_ce_n=%b, sram_oe_n=%b, sram_we_n=%b",
                         expected_data_out, expected_sram_addr, expected_sram_ce_n, expected_sram_oe_n, expected_sram_we_n);
                $display("  Got:      data_out=%h, sram_addr=%h, sram_ce_n=%b, sram_oe_n=%b, sram_we_n=%b",
                         data_out, sram_addr, sram_ce_n, sram_oe_n, sram_we_n);
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
        $dumpvars(0,address, clk, data_in, reset, write_enable, data_out, sram_addr, sram_ce_n, sram_oe_n, sram_we_n);
    end

endmodule
