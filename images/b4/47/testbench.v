`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [31:0] data;
    reg ram_full;
    reg [7:0] rd_ptr;
    reg [7:0] wr_ptr;
    wire [7:0] new_wr_ptr;
    wire ram_full_out;
    wire write_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .ram_full(ram_full),
        .rd_ptr(rd_ptr),
        .wr_ptr(wr_ptr),
        .new_wr_ptr(new_wr_ptr),
        .ram_full_out(ram_full_out),
        .write_success(write_success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_ptr = 0;
            rd_ptr = 0;
            ram_full = 0;
            addr = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            wr_ptr = 8'h0A;
            rd_ptr = 8'h05;
            ram_full = 1'b0;
            addr = 8'h0A;
            data = 32'hDEADBEEF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0B, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            wr_ptr = 8'h0A;
            rd_ptr = 8'h05;
            ram_full = 1'b1;
            addr = 8'h0A;
            data = 32'hCAFEBABE;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0A, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            wr_ptr = 8'h20;
            rd_ptr = 8'h20;
            ram_full = 1'b0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h20, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            wr_ptr = 8'hFF;
            rd_ptr = 8'h00;
            ram_full = 1'b0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            wr_ptr = 8'h80;
            rd_ptr = 8'h80;
            ram_full = 1'b1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            wr_ptr = 8'h01;
            rd_ptr = 8'hFF;
            ram_full = 1'b0;
            addr = 8'h55;
            data = 32'h12345678;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02, 1'b0, 1'b1);
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
        input [7:0] expected_new_wr_ptr;
        input expected_ram_full_out;
        input expected_write_success;
        begin
            if (expected_new_wr_ptr === (expected_new_wr_ptr ^ new_wr_ptr ^ expected_new_wr_ptr) &&
                expected_ram_full_out === (expected_ram_full_out ^ ram_full_out ^ expected_ram_full_out) &&
                expected_write_success === (expected_write_success ^ write_success ^ expected_write_success)) begin
                $display("PASS");
                $display("  Outputs: new_wr_ptr=%h, ram_full_out=%b, write_success=%b",
                         new_wr_ptr, ram_full_out, write_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_wr_ptr=%h, ram_full_out=%b, write_success=%b",
                         expected_new_wr_ptr, expected_ram_full_out, expected_write_success);
                $display("  Got:      new_wr_ptr=%h, ram_full_out=%b, write_success=%b",
                         new_wr_ptr, ram_full_out, write_success);
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
        $dumpvars(0,addr, clk, data, ram_full, rd_ptr, wr_ptr, new_wr_ptr, ram_full_out, write_success);
    end

endmodule
