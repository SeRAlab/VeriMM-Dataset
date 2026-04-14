`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] address;
    reg [1:0] byteenable;
    reg clk;
    reg read;
    reg reset;
    reg write;
    reg [15:0] writedata;
    wire [17:0] SRAM_ADDR;
    wire SRAM_CE_N;
    wire SRAM_LB_N;
    wire SRAM_OE_N;
    wire SRAM_UB_N;
    wire SRAM_WE_N;
    wire [15:0] readdata;
    wire readdatavalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .byteenable(byteenable),
        .clk(clk),
        .read(read),
        .reset(reset),
        .write(write),
        .writedata(writedata),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_CE_N(SRAM_CE_N),
        .SRAM_LB_N(SRAM_LB_N),
        .SRAM_OE_N(SRAM_OE_N),
        .SRAM_UB_N(SRAM_UB_N),
        .SRAM_WE_N(SRAM_WE_N),
        .readdata(readdata),
        .readdatavalid(readdatavalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            byteenable = 0;
            read = 0;
            write = 0;
            writedata = 0;
            sram_dq_en = 0;
            sram_dq_drive_reg = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset state verification");
            reset_dut();

            #1;


            check_outputs(18'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Full Write Operation");
            reset_dut();
            @(posedge clk);
            address = 18'h12345;
            writedata = 16'hABCD;
            byteenable = 2'b11;
            write = 1;
            @(posedge clk);
            write = 0;

            #1;


            check_outputs(18'h12345, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 16'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full Read Operation");
            reset_dut();
            @(posedge clk);
            address = 18'h0A0A0;
            byteenable = 2'b11;
            read = 1;
            @(posedge clk);

            sram_dq_en = 1;
            sram_dq_drive_reg = 16'h55AA;
            read = 0;
            @(posedge clk);
            sram_dq_en = 0;

            #1;


            check_outputs(18'h0A0A0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 16'h55AA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Lower Byte Write Only");
            reset_dut();
            @(posedge clk);
            address = 18'h3FFFF;
            writedata = 16'hFF00;
            byteenable = 2'b01;
            write = 1;
            @(posedge clk);
            write = 0;

            #1;


            check_outputs(18'h3FFFF, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 16'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Upper Byte Read Only");
            reset_dut();
            @(posedge clk);
            address = 18'h00001;
            byteenable = 2'b10;
            read = 1;
            @(posedge clk);
            sram_dq_en = 1;
            sram_dq_drive_reg = 16'hEE11;
            read = 0;
            @(posedge clk);
            sram_dq_en = 0;

            #1;


            check_outputs(18'h00001, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 16'hEE11, 1'b1);
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
        input [17:0] expected_SRAM_ADDR;
        input expected_SRAM_CE_N;
        input expected_SRAM_LB_N;
        input expected_SRAM_OE_N;
        input expected_SRAM_UB_N;
        input expected_SRAM_WE_N;
        input [15:0] expected_readdata;
        input expected_readdatavalid;
        begin
            if (expected_SRAM_ADDR === (expected_SRAM_ADDR ^ SRAM_ADDR ^ expected_SRAM_ADDR) &&
                expected_SRAM_CE_N === (expected_SRAM_CE_N ^ SRAM_CE_N ^ expected_SRAM_CE_N) &&
                expected_SRAM_LB_N === (expected_SRAM_LB_N ^ SRAM_LB_N ^ expected_SRAM_LB_N) &&
                expected_SRAM_OE_N === (expected_SRAM_OE_N ^ SRAM_OE_N ^ expected_SRAM_OE_N) &&
                expected_SRAM_UB_N === (expected_SRAM_UB_N ^ SRAM_UB_N ^ expected_SRAM_UB_N) &&
                expected_SRAM_WE_N === (expected_SRAM_WE_N ^ SRAM_WE_N ^ expected_SRAM_WE_N) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata) &&
                expected_readdatavalid === (expected_readdatavalid ^ readdatavalid ^ expected_readdatavalid)) begin
                $display("PASS");
                $display("  Outputs: SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, readdata=%h, readdatavalid=%b",
                         SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, readdata, readdatavalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, readdata=%h, readdatavalid=%b",
                         expected_SRAM_ADDR, expected_SRAM_CE_N, expected_SRAM_LB_N, expected_SRAM_OE_N, expected_SRAM_UB_N, expected_SRAM_WE_N, expected_readdata, expected_readdatavalid);
                $display("  Got:      SRAM_ADDR=%h, SRAM_CE_N=%b, SRAM_LB_N=%b, SRAM_OE_N=%b, SRAM_UB_N=%b, SRAM_WE_N=%b, readdata=%h, readdatavalid=%b",
                         SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, readdata, readdatavalid);
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
        $dumpvars(0,address, byteenable, clk, read, reset, write, writedata, SRAM_ADDR, SRAM_CE_N, SRAM_LB_N, SRAM_OE_N, SRAM_UB_N, SRAM_WE_N, readdata, readdatavalid);
    end

endmodule
