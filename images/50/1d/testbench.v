`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] mux_ctrl;
    reg [7:0] mux_input_a;
    reg [7:0] mux_input_b;
    reg [7:0] mux_input_c;
    reg [3:0] read_addr;
    reg read_en;
    reg rst_n;
    reg [3:0] write_addr;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] bitwise_or_output;
    wire [7:0] mux_output;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mux_ctrl(mux_ctrl),
        .mux_input_a(mux_input_a),
        .mux_input_b(mux_input_b),
        .mux_input_c(mux_input_c),
        .read_addr(read_addr),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .bitwise_or_output(bitwise_or_output),
        .mux_output(mux_output),
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
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_en = 0;
            read_addr = 0;
            mux_ctrl = 0;
            mux_input_a = 0;
            mux_input_b = 0;
            mux_input_c = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 4'h5;
            write_data = 8'hAA;

            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 4'h5;
            mux_ctrl = 2'b00;
            mux_input_a = 8'h55;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFF, 8'h55, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 4'hA;
            write_data = 8'hF0;

            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 4'hA;
            mux_ctrl = 2'b01;
            mux_input_b = 8'h0F;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFF, 8'h0F, 8'hF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 4'h2;
            write_data = 8'h12;

            @(posedge clk);
            write_en = 0;


            read_en = 1;
            read_addr = 4'h2;
            mux_ctrl = 2'b10;
            mux_input_c = 8'h48;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h5A, 8'h48, 8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 4'h0;
            write_data = 8'hFF;

            @(posedge clk);
            write_en = 0;


            read_en = 0;
            read_addr = 4'h0;
            mux_ctrl = 2'b00;
            mux_input_a = 8'h11;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11, 8'h11, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            write_en = 1;
            write_addr = 4'h1;
            write_data = 8'h33;
            @(posedge clk);


            write_addr = 4'h2;
            write_data = 8'hCC;
            read_en = 1;
            read_addr = 4'h1;
            mux_ctrl = 2'b01;
            mux_input_b = 8'h44;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h77, 8'h44, 8'h33);
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
        input [7:0] expected_bitwise_or_output;
        input [7:0] expected_mux_output;
        input [7:0] expected_read_data;
        begin
            if (expected_bitwise_or_output === (expected_bitwise_or_output ^ bitwise_or_output ^ expected_bitwise_or_output) &&
                expected_mux_output === (expected_mux_output ^ mux_output ^ expected_mux_output) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: bitwise_or_output=%h, mux_output=%h, read_data=%h",
                         bitwise_or_output, mux_output, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bitwise_or_output=%h, mux_output=%h, read_data=%h",
                         expected_bitwise_or_output, expected_mux_output, expected_read_data);
                $display("  Got:      bitwise_or_output=%h, mux_output=%h, read_data=%h",
                         bitwise_or_output, mux_output, read_data);
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
        $dumpvars(0,clk, mux_ctrl, mux_input_a, mux_input_b, mux_input_c, read_addr, read_en, rst_n, write_addr, write_data, write_en, bitwise_or_output, mux_output, read_data);
    end

endmodule
