`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] read_addr0;
    reg reset_n;
    reg rst;
    reg wr;
    reg [31:0] write_data;
    wire [31:0] read_data0;
    wire [31:0] read_data1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cs(cs),
        .read_addr0(read_addr0),
        .reset_n(reset_n),
        .rst(rst),
        .wr(wr),
        .write_data(write_data),
        .read_data0(read_data0),
        .read_data1(read_data1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            rst = 0;
            cs = 0;
            wr = 0;
            write_data = 0;
            read_addr0 = 0;
            #15;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            cs = 1;
            wr = 1;
            write_data = 32'hAAAA_BBBB;
            @(posedge clk);
            wr = 0;
            read_addr0 = 8'h00;



            #5;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            cs = 1;
            wr = 1;
            write_data = 32'h1111_1111;
            @(posedge clk);
            write_data = 32'h2222_2222;
            @(posedge clk);
            write_data = 32'h3333_3333;
            @(posedge clk);
            wr = 0;
            read_addr0 = 8'h01;

            #5;
            #1;

            check_outputs(32'h2222_2222, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            cs = 1;
            wr = 1;
            write_data = 32'h5555_5555;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            write_data = 32'hFFFF_FFFF;
            @(posedge clk);
            wr = 0;
            read_addr0 = 8'h00;

            #5;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            cs = 0;
            wr = 1;
            write_data = 32'hDEAD_BEEF;
            @(posedge clk);
            cs = 1;
            wr = 0;
            read_addr0 = 8'h00;

            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            cs = 1;
            wr = 1;
            write_data = 32'hCCCC_DDDD;
            @(posedge clk);
            wr = 0;


            wr = 1;
            write_data = 32'hEEEE_FFFF;
            read_addr0 = 8'h00;
            @(posedge clk);
            wr = 0;



            #5;
            #1;

            check_outputs(32'hCCCC_DDDD, 32'h0);
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
        input [31:0] expected_read_data0;
        input [31:0] expected_read_data1;
        begin
            if (expected_read_data0 === (expected_read_data0 ^ read_data0 ^ expected_read_data0) &&
                expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1)) begin
                $display("PASS");
                $display("  Outputs: read_data0=%h, read_data1=%h",
                         read_data0, read_data1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data0=%h, read_data1=%h",
                         expected_read_data0, expected_read_data1);
                $display("  Got:      read_data0=%h, read_data1=%h",
                         read_data0, read_data1);
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
        $dumpvars(0,clk, cs, read_addr0, reset_n, rst, wr, write_data, read_data0, read_data1);
    end

endmodule
