`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg copy_in_progress;
    reg [15:0] cpu_addr;
    reg cpu_clk;
    reg cpu_mreq;
    reg cpu_rd;
    reg cpu_wr;
    reg pclk;
    wire [12:0] back_vram_addr;
    wire [7:0] back_vram_data;
    wire back_vram_wr_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .copy_in_progress(copy_in_progress),
        .cpu_addr(cpu_addr),
        .cpu_clk(cpu_clk),
        .cpu_mreq(cpu_mreq),
        .cpu_rd(cpu_rd),
        .cpu_wr(cpu_wr),
        .pclk(pclk),
        .back_vram_addr(back_vram_addr),
        .back_vram_data(back_vram_data),
        .back_vram_wr_low(back_vram_wr_low)
    );

    // Clock generation (10ns period)
    initial begin
        cpu_clk = 0;
        forever #5 cpu_clk = ~cpu_clk;
    end

        task reset_dut;

    begin
        copy_in_progress = 0;
        cpu_addr = 16'h0000;
        cpu_mreq = 1;
        cpu_rd = 1;
        cpu_wr = 1;
        drive_cpu_bus = 0;
        tb_cpu_data_reg = 8'h00;
        @(posedge cpu_clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic VRAM Write (Copy=0, WR=0)", test_num);
        reset_dut();

        copy_in_progress = 0;
        cpu_mreq = 0;
        cpu_wr = 0;
        cpu_addr = 16'h1234;
        tb_cpu_data_reg = 8'hA5;
        drive_cpu_bus = 1;

        @(posedge cpu_clk);
        #5;
        #1;

        check_outputs(13'h1234, 8'hA5, 0);
        drive_cpu_bus = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Copy in progress (Outputs should be Z)", test_num);
        reset_dut();

        copy_in_progress = 1;
        cpu_mreq = 0;
        cpu_wr = 0;
        cpu_addr = 16'h5555;
        tb_cpu_data_reg = 8'hFF;
        drive_cpu_bus = 1;

        @(posedge cpu_clk);
        #5;

        #1;


        check_outputs(13'bz, 8'bz, 1'b1);
        drive_cpu_bus = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: CPU Read Operation (back_vram_wr_low should be high)", test_num);
        reset_dut();

        copy_in_progress = 0;
        cpu_mreq = 0;
        cpu_rd = 0;
        cpu_wr = 1;
        cpu_addr = 16'h0ABC;
        drive_cpu_bus = 0;

        @(posedge cpu_clk);
        #5;

        #1;


        check_outputs(13'h0ABC, 8'bz, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Address Adjustment (Truncation to 13-bit)", test_num);
        reset_dut();

        copy_in_progress = 0;
        cpu_mreq = 0;
        cpu_wr = 0;
        cpu_addr = 16'hEFFF;
        tb_cpu_data_reg = 8'h5A;
        drive_cpu_bus = 1;

        @(posedge cpu_clk);
        #5;

        #1;


        check_outputs(13'h0FFF, 8'h5A, 0);
        drive_cpu_bus = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Transition from Copy mode to Write mode", test_num);
        reset_dut();


        copy_in_progress = 1;
        @(posedge cpu_clk);
        #2;


        copy_in_progress = 0;
        cpu_mreq = 0;
        cpu_wr = 0;
        cpu_addr = 16'h0777;
        tb_cpu_data_reg = 8'hBD;
        drive_cpu_bus = 1;

        @(posedge cpu_clk);
        #5;
        #1;

        check_outputs(13'h0777, 8'hBD, 0);
        drive_cpu_bus = 0;
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
        input [12:0] expected_back_vram_addr;
        input [7:0] expected_back_vram_data;
        input expected_back_vram_wr_low;
        begin
            if (expected_back_vram_addr === (expected_back_vram_addr ^ back_vram_addr ^ expected_back_vram_addr) &&
                expected_back_vram_data === (expected_back_vram_data ^ back_vram_data ^ expected_back_vram_data) &&
                expected_back_vram_wr_low === (expected_back_vram_wr_low ^ back_vram_wr_low ^ expected_back_vram_wr_low)) begin
                $display("PASS");
                $display("  Outputs: back_vram_addr=%h, back_vram_data=%h, back_vram_wr_low=%b",
                         back_vram_addr, back_vram_data, back_vram_wr_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: back_vram_addr=%h, back_vram_data=%h, back_vram_wr_low=%b",
                         expected_back_vram_addr, expected_back_vram_data, expected_back_vram_wr_low);
                $display("  Got:      back_vram_addr=%h, back_vram_data=%h, back_vram_wr_low=%b",
                         back_vram_addr, back_vram_data, back_vram_wr_low);
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
        $dumpvars(0,copy_in_progress, cpu_addr, cpu_clk, cpu_mreq, cpu_rd, cpu_wr, pclk, back_vram_addr, back_vram_data, back_vram_wr_low);
    end

endmodule
