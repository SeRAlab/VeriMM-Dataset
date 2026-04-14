`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] mux_in_0;
    reg [3:0] mux_in_1;
    reg [3:0] mux_in_2;
    reg [3:0] mux_in_3;
    reg [1:0] mux_sel;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mux_in_0(mux_in_0),
        .mux_in_1(mux_in_1),
        .mux_in_2(mux_in_2),
        .mux_in_3(mux_in_3),
        .mux_sel(mux_sel),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_en = 0;
            read_addr = 0;
            mux_in_0 = 0;
            mux_in_1 = 0;
            mux_in_2 = 0;
            mux_in_3 = 0;
            mux_sel = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Reset state check");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Mux Selection 0");
            mux_in_0 = 4'hA;
            read_en = 1;
            mux_sel = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Mux Selection 1");
            mux_in_1 = 4'hB;
            read_en = 1;
            mux_sel = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hB);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Mux Selection 2");
            mux_in_2 = 4'hC;
            read_en = 1;
            mux_sel = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: RAM Write and Read (Mux 3)");

            write_en = 1;
            write_addr = 8'h03;
            write_data = 4'hD;
            @(posedge clk);
            #1 write_en = 0;

            read_en = 1;
            mux_sel = 2'b11;
            read_addr = 8'h03;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hD);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Read Enable Gating");

            mux_in_0 = 4'h5;
            read_en = 1;
            mux_sel = 2'b00;
            @(posedge clk);
            #1;

            read_en = 0;
            mux_in_0 = 4'hF;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Write Enable Gating");

            write_en = 0;
            write_addr = 8'h04;
            write_data = 4'h9;
            @(posedge clk);
            #1;

            read_en = 1;
            mux_sel = 2'b11;
            read_addr = 8'h04;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: RAM Boundary Address 7");
            write_en = 1;
            write_addr = 8'h07;
            write_data = 4'hE;
            @(posedge clk);
            #1 write_en = 0;
            read_en = 1;
            mux_sel = 2'b11;
            read_addr = 8'h07;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hE);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, mux_in_0, mux_in_1, mux_in_2, mux_in_3, mux_sel, read_addr, read_en, rst_n, write_addr, write_data, write_en, out);
    end

endmodule
