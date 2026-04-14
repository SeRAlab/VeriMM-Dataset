`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg [21:0] chr_addr;
    reg [7:0] chr_din;
    reg chr_read;
    reg chr_write;
    reg clk;
    reg [21:0] prg_addr;
    reg [7:0] prg_din;
    reg prg_read;
    reg prg_write;
    wire [21:0] memory_addr;
    wire [7:0] memory_dout;
    wire memory_read_cpu;
    wire memory_read_ppu;
    wire memory_write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .chr_addr(chr_addr),
        .chr_din(chr_din),
        .chr_read(chr_read),
        .chr_write(chr_write),
        .clk(clk),
        .prg_addr(prg_addr),
        .prg_din(prg_din),
        .prg_read(prg_read),
        .prg_write(prg_write),
        .memory_addr(memory_addr),
        .memory_dout(memory_dout),
        .memory_read_cpu(memory_read_cpu),
        .memory_read_ppu(memory_read_ppu),
        .memory_write(memory_write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            chr_addr = 0;
            chr_din = 0;
            chr_read = 0;
            chr_write = 0;
            prg_addr = 0;
            prg_din = 0;
            prg_read = 0;
            prg_write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            ce = 1;
            prg_addr = 22'h100001;
            prg_read = 1;
            prg_write = 0;
            chr_read = 0;
            chr_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(22'h100001, 8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ce = 1;
            prg_addr = 22'h2AAAAA;
            prg_din = 8'h55;
            prg_read = 0;
            prg_write = 1;
            chr_read = 0;
            chr_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(22'h2AAAAA, 8'h55, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ce = 1;
            prg_addr = 22'h111111;
            chr_addr = 22'h000ABC;
            chr_read = 1;
            chr_write = 0;
            prg_read = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(22'h000ABC, 8'h00, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ce = 1;
            chr_addr = 22'h000F0F;
            chr_din = 8'hAA;
            chr_read = 0;
            chr_write = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(22'h000F0F, 8'hAA, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            ce = 1;
            prg_addr = 22'h123456;
            chr_addr = 22'h000111;
            prg_din = 8'h11;
            chr_din = 8'h22;
            prg_read = 1;
            chr_read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(22'h000111, 8'h22, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            ce = 1;
            prg_read = 1;
            prg_write = 0;
            @(posedge clk);
            #1;

            ce = 0;
            prg_read = 0;
            prg_write = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(22'h000000, 8'h00, 1'b1, 1'b0, 1'b0);
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
        input [21:0] expected_memory_addr;
        input [7:0] expected_memory_dout;
        input expected_memory_read_cpu;
        input expected_memory_read_ppu;
        input expected_memory_write;
        begin
            if (expected_memory_addr === (expected_memory_addr ^ memory_addr ^ expected_memory_addr) &&
                expected_memory_dout === (expected_memory_dout ^ memory_dout ^ expected_memory_dout) &&
                expected_memory_read_cpu === (expected_memory_read_cpu ^ memory_read_cpu ^ expected_memory_read_cpu) &&
                expected_memory_read_ppu === (expected_memory_read_ppu ^ memory_read_ppu ^ expected_memory_read_ppu) &&
                expected_memory_write === (expected_memory_write ^ memory_write ^ expected_memory_write)) begin
                $display("PASS");
                $display("  Outputs: memory_addr=%h, memory_dout=%h, memory_read_cpu=%b, memory_read_ppu=%b, memory_write=%b",
                         memory_addr, memory_dout, memory_read_cpu, memory_read_ppu, memory_write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_addr=%h, memory_dout=%h, memory_read_cpu=%b, memory_read_ppu=%b, memory_write=%b",
                         expected_memory_addr, expected_memory_dout, expected_memory_read_cpu, expected_memory_read_ppu, expected_memory_write);
                $display("  Got:      memory_addr=%h, memory_dout=%h, memory_read_cpu=%b, memory_read_ppu=%b, memory_write=%b",
                         memory_addr, memory_dout, memory_read_cpu, memory_read_ppu, memory_write);
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
        $dumpvars(0,ce, chr_addr, chr_din, chr_read, chr_write, clk, prg_addr, prg_din, prg_read, prg_write, memory_addr, memory_dout, memory_read_cpu, memory_read_ppu, memory_write);
    end

endmodule
