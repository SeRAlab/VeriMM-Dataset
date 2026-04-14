`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [2:0] MAC_add_prom_add;
    reg [7:0] MAC_add_prom_data;
    reg MAC_add_prom_wr;
    reg MAC_tx_addr_init;
    reg MAC_tx_addr_rd;
    reg Reset;
    wire [7:0] MAC_tx_addr_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .MAC_add_prom_add(MAC_add_prom_add),
        .MAC_add_prom_data(MAC_add_prom_data),
        .MAC_add_prom_wr(MAC_add_prom_wr),
        .MAC_tx_addr_init(MAC_tx_addr_init),
        .MAC_tx_addr_rd(MAC_tx_addr_rd),
        .Reset(Reset),
        .MAC_tx_addr_data(MAC_tx_addr_data)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            MAC_add_prom_add = 0;
            MAC_add_prom_data = 0;
            MAC_add_prom_wr = 0;
            MAC_tx_addr_init = 0;
            MAC_tx_addr_rd = 0;
            repeat(2) @(posedge Clk);
            Reset = 0;
            repeat(2) @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read at Address 0");
            reset_dut();


            @(posedge Clk);
            MAC_add_prom_add = 3'h0;
            MAC_add_prom_data = 8'hA5;
            MAC_add_prom_wr = 1;
            @(posedge Clk);
            MAC_add_prom_wr = 0;


            @(posedge Clk);
            MAC_tx_addr_init = 1;
            @(posedge Clk);
            MAC_tx_addr_init = 0;


            @(posedge Clk);
            MAC_tx_addr_rd = 1;
            @(posedge Clk);
            MAC_tx_addr_rd = 0;
            @(posedge Clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Sequential write and read increment");
            reset_dut();


            @(posedge Clk);
            MAC_add_prom_add = 3'h0; MAC_add_prom_data = 8'h11; MAC_add_prom_wr = 1;
            @(posedge Clk);
            MAC_add_prom_add = 3'h1; MAC_add_prom_data = 8'h22; MAC_add_prom_wr = 1;
            @(posedge Clk);
            MAC_add_prom_wr = 0;


            @(posedge Clk);
            MAC_tx_addr_init = 1;
            @(posedge Clk);
            MAC_tx_addr_init = 0;

            @(posedge Clk);
            MAC_tx_addr_rd = 1;
            @(posedge Clk);
            MAC_tx_addr_rd = 1;
            @(posedge Clk);
            MAC_tx_addr_rd = 0;
            @(posedge Clk);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write to address 7 and read sequence");
            reset_dut();


            @(posedge Clk);
            MAC_add_prom_add = 3'h7;
            MAC_add_prom_data = 8'hFF;
            MAC_add_prom_wr = 1;
            @(posedge Clk);
            MAC_add_prom_wr = 0;


            @(posedge Clk);
            MAC_tx_addr_init = 1;
            @(posedge Clk);
            MAC_tx_addr_init = 0;


            repeat(8) begin
                @(posedge Clk);
                MAC_tx_addr_rd = 1;
                @(posedge Clk);
                MAC_tx_addr_rd = 0;
            end
            @(posedge Clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: MAC_tx_addr_init mid-operation");
            reset_dut();


            @(posedge Clk);
            MAC_add_prom_add = 3'h0; MAC_add_prom_data = 8'h55; MAC_add_prom_wr = 1;
            @(posedge Clk);
            MAC_add_prom_wr = 0;


            @(posedge Clk);
            MAC_tx_addr_rd = 1;
            @(posedge Clk);
            MAC_tx_addr_rd = 1;
            @(posedge Clk);
            MAC_tx_addr_rd = 0;


            @(posedge Clk);
            MAC_tx_addr_init = 1;
            @(posedge Clk);
            MAC_tx_addr_init = 0;


            @(posedge Clk);
            MAC_tx_addr_rd = 1;
            @(posedge Clk);
            MAC_tx_addr_rd = 0;
            @(posedge Clk);

            #1;


            check_outputs(8'h55);
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
        input [7:0] expected_MAC_tx_addr_data;
        begin
            if (expected_MAC_tx_addr_data === (expected_MAC_tx_addr_data ^ MAC_tx_addr_data ^ expected_MAC_tx_addr_data)) begin
                $display("PASS");
                $display("  Outputs: MAC_tx_addr_data=%h",
                         MAC_tx_addr_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MAC_tx_addr_data=%h",
                         expected_MAC_tx_addr_data);
                $display("  Got:      MAC_tx_addr_data=%h",
                         MAC_tx_addr_data);
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
        $dumpvars(0,Clk, MAC_add_prom_add, MAC_add_prom_data, MAC_add_prom_wr, MAC_tx_addr_init, MAC_tx_addr_rd, Reset, MAC_tx_addr_data);
    end

endmodule
