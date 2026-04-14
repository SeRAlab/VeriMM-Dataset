`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg close_to_vlank;
    reg copy_in_progress;
    reg [15:0] cpu_addr;
    reg cpu_mreq;
    reg cpu_rd;
    reg cpu_wr;
    wire [12:0] back_vram_addr;
    wire [7:0] back_vram_data;
    wire back_vram_rd_low;
    wire back_vram_wr_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .close_to_vlank(close_to_vlank),
        .copy_in_progress(copy_in_progress),
        .cpu_addr(cpu_addr),
        .cpu_mreq(cpu_mreq),
        .cpu_rd(cpu_rd),
        .cpu_wr(cpu_wr),
        .back_vram_addr(back_vram_addr),
        .back_vram_data(back_vram_data),
        .back_vram_rd_low(back_vram_rd_low),
        .back_vram_wr_low(back_vram_wr_low)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            copy_in_progress = 0;
            close_to_vlank = 0;
            cpu_rd = 1;
            cpu_wr = 1;
            cpu_mreq = 1;
            cpu_addr = 0;
            cpu_data_tb_en = 0;
            cpu_data_tb_reg = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Standard Memory Write");
            reset_dut();
            test_num = 1;
            cpu_addr = 16'h1234;
            cpu_data_tb_reg = 8'hA5;
            cpu_data_tb_en = 1;
            cpu_mreq = 0;
            cpu_wr = 0;
            cpu_rd = 1;
            copy_in_progress = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'h1234, 8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Standard Memory Read");
            reset_dut();
            test_num = 2;
            cpu_addr = 16'h0ABC;
            cpu_mreq = 0;
            cpu_wr = 1;
            cpu_rd = 0;
            copy_in_progress = 0;
            cpu_data_tb_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'h0ABC, back_vram_data, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Blocked by Copy In Progress");
            reset_dut();
            test_num = 3;
            copy_in_progress = 1;
            cpu_addr = 16'h1FFF;
            cpu_data_tb_reg = 8'hFF;
            cpu_data_tb_en = 1;
            cpu_mreq = 0;
            cpu_wr = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(back_vram_addr, back_vram_data, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Address Masking (16-bit to 13-bit)");
            reset_dut();
            test_num = 4;
            cpu_addr = 16'hF001;
            cpu_mreq = 0;
            cpu_wr = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'h1001, back_vram_data, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Idle State (MREQ High)");
            reset_dut();
            test_num = 5;
            cpu_addr = 16'h4321;
            cpu_mreq = 1;
            cpu_wr = 0;
            cpu_rd = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(back_vram_addr, back_vram_data, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Write During Close to VBlank");
            reset_dut();
            test_num = 6;
            close_to_vlank = 1;
            cpu_addr = 16'h0123;
            cpu_data_tb_reg = 8'hCC;
            cpu_data_tb_en = 1;
            cpu_mreq = 0;
            cpu_wr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'h0123, 8'hCC, 1'b1, 1'b0);
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
        begin
            if (expected_back_vram_addr === (expected_back_vram_addr ^ back_vram_addr ^ expected_back_vram_addr) &&
                expected_back_vram_data === (expected_back_vram_data ^ back_vram_data ^ expected_back_vram_data) &&
                expected_back_vram_rd_low === (expected_back_vram_rd_low ^ back_vram_rd_low ^ expected_back_vram_rd_low) &&
                expected_back_vram_wr_low === (expected_back_vram_wr_low ^ back_vram_wr_low ^ expected_back_vram_wr_low)) begin
                $display("PASS");
                $display("  Outputs: back_vram_addr=%h, back_vram_data=%h, back_vram_rd_low=%b, back_vram_wr_low=%b",
                         back_vram_addr, back_vram_data, back_vram_rd_low, back_vram_wr_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: back_vram_addr=%h, back_vram_data=%h, back_vram_rd_low=%b, back_vram_wr_low=%b",
                         expected_back_vram_addr, expected_back_vram_data, expected_back_vram_rd_low, expected_back_vram_wr_low);
                $display("  Got:      back_vram_addr=%h, back_vram_data=%h, back_vram_rd_low=%b, back_vram_wr_low=%b",
                         back_vram_addr, back_vram_data, back_vram_rd_low, back_vram_wr_low);
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
        $dumpvars(0,clk, close_to_vlank, copy_in_progress, cpu_addr, cpu_mreq, cpu_rd, cpu_wr, back_vram_addr, back_vram_data, back_vram_rd_low, back_vram_wr_low);
    end

endmodule
