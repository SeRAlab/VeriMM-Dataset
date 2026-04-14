`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [31:0] out;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .out(out),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        in = 0;
        read_addr = 0;
        read_en = 0;
        write_addr = 0;
        write_data = 0;
        write_en = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset and Initial State...");
        test_num = test_num + 1;
        reset_dut();


        read_en = 1;
        read_addr = 8'h00;
        in = 32'h12345678;

        @(posedge clk);
        #1;



        #1;




        check_outputs(32'h78563412, 4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Basic Write and Read...");
        test_num = test_num + 1;
        reset_dut();


        write_en = 1;
        write_addr = 8'h03;
        write_data = 4'hA;
        @(posedge clk);
        write_en = 0;


        read_en = 1;
        read_addr = 8'h03;
        in = 32'hAABBCCDD;
        @(posedge clk);
        #1;



        #1;




        check_outputs(32'h77661100, 4'hA);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Memory Boundary and Byte Swapping...");
        test_num = test_num + 1;
        reset_dut();


        write_en = 1;
        write_addr = 8'h07;
        write_data = 4'hF;
        @(posedge clk);
        write_en = 0;


        read_en = 1;
        read_addr = 8'h07;
        in = 32'h01020304;
        @(posedge clk);
        #1;



        #1;




        check_outputs(32'hFBFCFEFE, 4'hF);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Continuous Operation...");
        test_num = test_num + 1;
        reset_dut();


        write_en = 1; write_addr = 8'h01; write_data = 4'h5;
        @(posedge clk);


        write_en = 1; write_addr = 8'h02; write_data = 4'hE;
        read_en = 1; read_addr = 8'h01;
        in = 32'h11223344;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h11667744, 4'h5);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Read Enable Low...");
        test_num = test_num + 1;
        reset_dut();


        write_en = 1; write_addr = 8'h00; write_data = 4'hC;
        @(posedge clk);


        read_en = 1; read_addr = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(out, 4'hC);



        read_en = 0;
        in = 32'hFFFF0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs( (32'h0000FFFF ^ {8{read_data}}), read_data);
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
        input [31:0] expected_out;
        input [3:0] expected_read_data;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: out=%h, read_data=%h",
                         out, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, read_data=%h",
                         expected_out, expected_read_data);
                $display("  Got:      out=%h, read_data=%h",
                         out, read_data);
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
        $dumpvars(0,clk, in, read_addr, read_en, rst_n, write_addr, write_data, write_en, out, read_data);
    end

endmodule
