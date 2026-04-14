`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg copy_in_progress;
    reg [15:0] cpu_addr;
    reg cpu_mreq;
    reg cpu_rd;
    reg cpu_wr;
    wire [12:0] back_vram_addr;
    wire [7:0] back_vram_data;
    wire back_vram_rd_low;
    wire back_vram_wr_low;
    wire [7:0] copy_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .copy_in_progress(copy_in_progress),
        .cpu_addr(cpu_addr),
        .cpu_mreq(cpu_mreq),
        .cpu_rd(cpu_rd),
        .cpu_wr(cpu_wr),
        .back_vram_addr(back_vram_addr),
        .back_vram_data(back_vram_data),
        .back_vram_rd_low(back_vram_rd_low),
        .back_vram_wr_low(back_vram_wr_low),
        .copy_enable(copy_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            copy_in_progress = 0;
            cpu_addr = 16'h0000;
            cpu_mreq = 0;
            cpu_rd = 0;
            cpu_wr = 0;
            drive_cpu_bus = 0;
            cpu_data_out_reg = 8'h00;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic VRAM Write (Addr: 0x4005, Data: 0x55)");

            @(posedge clk);
            cpu_addr = 16'h4005;
            cpu_mreq = 1;
            cpu_wr = 1;
            cpu_rd = 0;
            drive_cpu_bus = 1;
            cpu_data_out_reg = 8'h55;
            copy_in_progress = 0;

            #5;

            #1;


            check_outputs(13'h0005, 8'h55, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Basic VRAM Read (Addr: 0x4123)");

            @(posedge clk);
            cpu_addr = 16'h4123;
            cpu_mreq = 1;
            cpu_rd = 1;
            cpu_wr = 0;
            drive_cpu_bus = 0;
            copy_in_progress = 0;

            #5;

            #1;


            check_outputs(13'h0123, 8'hzz, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: VRAM Write Blocked (copy_in_progress=1)");

            @(posedge clk);
            copy_in_progress = 1;
            cpu_addr = 16'h4000;
            cpu_mreq = 1;
            cpu_wr = 1;
            drive_cpu_bus = 1;
            cpu_data_out_reg = 8'hAA;

            #5;

            #1;


            check_outputs(13'h0000, 8'hAA, 1'b1, 1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Write to copy_enable register (Addr: 0x6000, Data: 0x01)");

            @(posedge clk);
            cpu_addr = 16'h6000;
            cpu_mreq = 1;
            cpu_wr = 1;
            drive_cpu_bus = 1;
            cpu_data_out_reg = 8'h01;

            #15;

            #1;


            check_outputs(back_vram_addr, back_vram_data, 1'b1, 1'b1, 8'h01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: CPU Write with MREQ=0");

            @(posedge clk);
            cpu_addr = 16'h4000;
            cpu_mreq = 0;
            cpu_wr = 1;
            drive_cpu_bus = 1;
            cpu_data_out_reg = 8'hFF;

            #5;

            #1;


            check_outputs(back_vram_addr, 8'hFF, 1'b1, 1'b1, copy_enable);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Access out of VRAM range (Addr: 0x9000)");

            @(posedge clk);
            cpu_addr = 16'h9000;
            cpu_mreq = 1;
            cpu_wr = 1;

            #5;

            #1;


            check_outputs(back_vram_addr, back_vram_data, 1'b1, 1'b1, copy_enable);
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
        input [12:0] expected_back_vram_addr;
        input [7:0] expected_back_vram_data;
        input expected_back_vram_rd_low;
        input expected_back_vram_wr_low;
        input [7:0] expected_copy_enable;
        begin
            if (expected_back_vram_addr === (expected_back_vram_addr ^ back_vram_addr ^ expected_back_vram_addr) &&
                expected_back_vram_data === (expected_back_vram_data ^ back_vram_data ^ expected_back_vram_data) &&
                expected_back_vram_rd_low === (expected_back_vram_rd_low ^ back_vram_rd_low ^ expected_back_vram_rd_low) &&
                expected_back_vram_wr_low === (expected_back_vram_wr_low ^ back_vram_wr_low ^ expected_back_vram_wr_low) &&
                expected_copy_enable === (expected_copy_enable ^ copy_enable ^ expected_copy_enable)) begin
                $display("PASS");
                $display("  Outputs: back_vram_addr=%h, back_vram_data=%h, back_vram_rd_low=%b, back_vram_wr_low=%b, copy_enable=%h",
                         back_vram_addr, back_vram_data, back_vram_rd_low, back_vram_wr_low, copy_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: back_vram_addr=%h, back_vram_data=%h, back_vram_rd_low=%b, back_vram_wr_low=%b, copy_enable=%h",
                         expected_back_vram_addr, expected_back_vram_data, expected_back_vram_rd_low, expected_back_vram_wr_low, expected_copy_enable);
                $display("  Got:      back_vram_addr=%h, back_vram_data=%h, back_vram_rd_low=%b, back_vram_wr_low=%b, copy_enable=%h",
                         back_vram_addr, back_vram_data, back_vram_rd_low, back_vram_wr_low, copy_enable);
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
        $dumpvars(0,clk, copy_in_progress, cpu_addr, cpu_mreq, cpu_rd, cpu_wr, back_vram_addr, back_vram_data, back_vram_rd_low, back_vram_wr_low, copy_enable);
    end

endmodule
