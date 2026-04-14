`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg clk;
    reg rd_en;
    reg wr_en;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            rd_en = 0;
            address = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            wr_en = 1;
            address = 16'h0001;
            write_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_en = 1;
            address = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
            rd_en = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            wr_en = 1;
            address = 16'hFFFF;
            write_data = 32'hCAFEBABE;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_en = 1;
            address = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
            rd_en = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            wr_en = 1;
            address = 16'h0010;
            write_data = 32'h11111111;
            @(posedge clk);
            #1;

            write_data = 32'h22222222;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_en = 1;
            address = 16'h0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h22222222);
            rd_en = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wr_en = 1; address = 16'h0100; write_data = 32'hAAAA0000;
            @(posedge clk); #1;

            address = 16'h0200; write_data = 32'hBBBB0000;
            @(posedge clk); #1;
            wr_en = 0;

            rd_en = 1; address = 16'h0100;
            @(posedge clk); #1;

            address = 16'h0200;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hBBBB0000);
            rd_en = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            wr_en = 1; address = 16'h0005; write_data = 32'h55555555;
            @(posedge clk); #1;

            wr_en = 1; address = 16'h0006; write_data = 32'h66666666;
            @(posedge clk); #1;
            wr_en = 0;

            rd_en = 1; address = 16'h0005;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h55555555);
            rd_en = 0;
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
        input [31:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,address, clk, rd_en, wr_en, write_data, read_data);
    end

endmodule
