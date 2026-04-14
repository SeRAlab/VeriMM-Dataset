`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg [7:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [3:0] write_addr;
    reg [7:0] write_data;
    reg write_en;
    wire [3:0] functional_output;
    wire out_and;
    wire out_or;
    wire out_xor;
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
        .functional_output(functional_output),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
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
        in = 4'b0000;
        read_addr = 8'h00;
        read_en = 0;
        write_addr = 4'h0;
        write_data = 8'h00;
        write_en = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset and Default Logic Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: RAM Write/Read and Logic All-On", test_num);
        reset_dut();
        @(negedge clk);
        write_en = 1; write_addr = 4'h2; write_data = 8'hA5;
        @(posedge clk);
        #1 write_en = 0; read_en = 1; read_addr = 8'h02; in = 4'b1111;
        @(posedge clk);
        #1;



        #1;




        check_outputs(4'h9, 1'b1, 1'b1, 1'b0, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: RAM Write/Read and Logic Mixed", test_num);
        reset_dut();
        @(negedge clk);
        write_en = 1; write_addr = 4'h7; write_data = 8'h2B;
        @(posedge clk);
        #1 write_en = 0; read_en = 1; read_addr = 8'h07; in = 4'b1010;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'hF, 1'b0, 1'b1, 1'b0, 4'hB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: RAM Max Data and Logic XOR check", test_num);
        reset_dut();
        @(negedge clk);
        write_en = 1; write_addr = 4'h0; write_data = 8'hFF;
        @(posedge clk);
        #1 write_en = 0; read_en = 1; read_addr = 8'h00; in = 4'b0001;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h9, 1'b0, 1'b1, 1'b1, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Boundary Check and Single-bit Logic", test_num);
        reset_dut();
        @(negedge clk);
        write_en = 1; write_addr = 4'h3; write_data = 8'h12;
        @(posedge clk);
        #1 write_en = 0; read_en = 1; read_addr = 8'h03; in = 4'b1000;
        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h4, 1'b0, 1'b1, 1'b1, 4'h2);
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
        input [3:0] expected_functional_output;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        input [3:0] expected_read_data;
        begin
            if (expected_functional_output === (expected_functional_output ^ functional_output ^ expected_functional_output) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: functional_output=%h, out_and=%b, out_or=%b, out_xor=%b, read_data=%h",
                         functional_output, out_and, out_or, out_xor, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: functional_output=%h, out_and=%b, out_or=%b, out_xor=%b, read_data=%h",
                         expected_functional_output, expected_out_and, expected_out_or, expected_out_xor, expected_read_data);
                $display("  Got:      functional_output=%h, out_and=%b, out_or=%b, out_xor=%b, read_data=%h",
                         functional_output, out_and, out_or, out_xor, read_data);
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
        $dumpvars(0,clk, in, read_addr, read_en, rst_n, write_addr, write_data, write_en, functional_output, out_and, out_or, out_xor, read_data);
    end

endmodule
