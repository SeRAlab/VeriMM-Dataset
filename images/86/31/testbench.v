`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] and_output;
    wire [3:0] out1;
    wire [3:0] out2;
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
        .and_output(and_output),
        .out1(out1),
        .out2(out2),
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
        @(posedge clk);
        #2 rst_n = 1;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_addr = 8'h03;
        write_data = 4'h5;
        write_en = 1;
        @(posedge clk);
        #2;

        write_en = 0;
        read_en = 1;
        read_addr = 8'h03;
        in = 4'h7;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'h5, 4'h7, 4'h7, 4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();

        in = 4'hD;
        write_en = 1;

        #2;
        #1;

        check_outputs(4'h0, 4'hD, 4'hA, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_addr = 8'h02;
        write_data = 4'hF;
        write_en = 1;
        @(posedge clk);
        #2;

        read_en = 1;
        read_addr = 8'h02;
        write_en = 1;
        in = 4'h3;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'h6, 4'h3, 4'h6, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_addr = 8'h87;
        write_data = 4'hB;
        write_en = 1;
        @(posedge clk);
        #2;
        write_en = 0;
        read_en = 1;
        read_addr = 8'h07;
        in = 4'hE;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'hA, 4'hE, 4'hE, 4'hB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_addr = 8'h04;
        write_data = 4'hC;
        write_en = 1;
        @(posedge clk);
        #2;

        read_en = 1;
        read_addr = 8'h04;
        @(posedge clk);
        #2;

        read_en = 0;
        read_addr = 8'h00;
        in = 4'hF;
        @(posedge clk);
        #2;


        #1;



        check_outputs(4'hC, 4'hF, 4'hF, 4'hC);
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
        input [3:0] expected_and_output;
        input [3:0] expected_out1;
        input [3:0] expected_out2;
        input [3:0] expected_read_data;
        begin
            if (expected_and_output === (expected_and_output ^ and_output ^ expected_and_output) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: and_output=%h, out1=%h, out2=%h, read_data=%h",
                         and_output, out1, out2, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_output=%h, out1=%h, out2=%h, read_data=%h",
                         expected_and_output, expected_out1, expected_out2, expected_read_data);
                $display("  Got:      and_output=%h, out1=%h, out2=%h, read_data=%h",
                         and_output, out1, out2, read_data);
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
        $dumpvars(0,clk, in, read_addr, read_en, rst_n, write_addr, write_data, write_en, and_output, out1, out2, read_data);
    end

endmodule
