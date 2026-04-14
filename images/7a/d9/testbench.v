`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control;
    reg [7:0] read_addr_1;
    reg [7:0] read_addr_2;
    reg rst_n;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    reg write_en;
    wire [3:0] read_data_1;
    wire [3:0] read_data_2;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            write_en = 0;
            control = 0;
            write_addr = 0;
            write_data = 0;
            read_addr_1 = 0;
            read_addr_2 = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (5 + 3)", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 8'h00;
            write_data = 4'h5;


            @(posedge clk);
            write_en = 1;
            write_addr = 8'h01;
            write_data = 4'h3;


            @(posedge clk);
            write_en = 0;
            read_addr_1 = 8'h00;
            read_addr_2 = 8'h01;
            control = 3'b000;


            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 4'h3, 4'h8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction (10 - 4)", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 8'h02;
            write_data = 4'd10;


            @(posedge clk);
            write_en = 1;
            write_addr = 8'h03;
            write_data = 4'd4;


            @(posedge clk);
            write_en = 0;
            read_addr_1 = 8'h02;
            read_addr_2 = 8'h03;
            control = 3'b001;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 4'd4, 4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow (12 + 5)", test_num);
            reset_dut();

            @(posedge clk);
            write_en = 1; write_addr = 8'h04; write_data = 4'd12;
            @(posedge clk);
            write_en = 1; write_addr = 8'h05; write_data = 4'd5;

            @(posedge clk);
            write_en = 0;
            read_addr_1 = 8'h04;
            read_addr_2 = 8'h05;
            control = 3'b000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd12, 4'd5, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Underflow (3 - 5)", test_num);
            reset_dut();

            @(posedge clk);
            write_en = 1; write_addr = 8'h06; write_data = 4'd3;
            @(posedge clk);
            write_en = 1; write_addr = 8'h07; write_data = 4'd5;

            @(posedge clk);
            write_en = 0;
            read_addr_1 = 8'h06;
            read_addr_2 = 8'h07;
            control = 3'b001;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd5, 4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Same Address Subtraction (7 - 7)", test_num);
            reset_dut();

            @(posedge clk);
            write_en = 1; write_addr = 8'h00; write_data = 4'd7;

            @(posedge clk);
            write_en = 0;
            read_addr_1 = 8'h00;
            read_addr_2 = 8'h00;
            control = 3'b001;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 4'd7, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Async Reset Mid-Operation", test_num);
            reset_dut();

            @(posedge clk);
            write_en = 1; write_addr = 8'h01; write_data = 4'hF;
            @(posedge clk);
            write_en = 0; read_addr_1 = 8'h01;

            @(posedge clk);
            #2;
            rst_n = 0;
            #5;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
            rst_n = 1;
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
        input [3:0] expected_read_data_1;
        input [3:0] expected_read_data_2;
        input [3:0] expected_result;
        begin
            if (expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1) &&
                expected_read_data_2 === (expected_read_data_2 ^ read_data_2 ^ expected_read_data_2) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: read_data_1=%h, read_data_2=%h, result=%h",
                         read_data_1, read_data_2, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_1=%h, read_data_2=%h, result=%h",
                         expected_read_data_1, expected_read_data_2, expected_result);
                $display("  Got:      read_data_1=%h, read_data_2=%h, result=%h",
                         read_data_1, read_data_2, result);
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
        $dumpvars(0,clk, control, read_addr_1, read_addr_2, rst_n, write_addr, write_data, write_en, read_data_1, read_data_2, result);
    end

endmodule
