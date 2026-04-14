`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_b;
    reg clk;
    reg [31:0] data_b_in;
    reg [31:0] data_b_we;
    reg rst;
    reg [7:0] uart_din;
    reg uart_valid;
    wire [31:0] data_b;
    wire strobe_b;
    wire [7:0] uart_dout;
    wire uart_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_b(addr_b),
        .clk(clk),
        .data_b_in(data_b_in),
        .data_b_we(data_b_we),
        .rst(rst),
        .uart_din(uart_din),
        .uart_valid(uart_valid),
        .data_b(data_b),
        .strobe_b(strobe_b),
        .uart_dout(uart_dout),
        .uart_wr(uart_wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_b = 0;
            data_b_in = 0;
            data_b_we = 0;
            uart_din = 0;
            uart_valid = 0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: UART Receive to Memory Read", test_num);
            reset_dut();


            @(posedge clk);
            uart_din = 8'hA5;
            uart_valid = 1;
            @(posedge clk);
            uart_valid = 0;
            uart_din = 0;


            @(posedge clk);
            addr_b = 32'h0000_0000;
            data_b_we = 32'h0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h0000_00A5, 1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Memory Write to UART Transmit", test_num);
            reset_dut();


            @(posedge clk);
            addr_b = 32'h0000_0000;
            data_b_in = 32'h0000_005A;
            data_b_we = 32'h0000_000F;

            @(posedge clk);

            #1;
            #1;

            check_outputs(data_b, strobe_b, 8'h5A, 1'b1);


            @(posedge clk);
            data_b_we = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Status Register Read", test_num);
            reset_dut();


            @(posedge clk);
            uart_din = 8'hFF;
            uart_valid = 1;
            @(posedge clk);
            uart_valid = 0;


            @(posedge clk);
            addr_b = 32'h0000_0004;
            data_b_we = 0;

            repeat(2) @(posedge clk);

            if (strobe_b === 1'b1) begin
                $display("PASS: Status register responded with strobe.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Status register did not assert strobe.");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_data_b;
        input expected_strobe_b;
        input [7:0] expected_uart_dout;
        input expected_uart_wr;
        begin
            if (expected_data_b === (expected_data_b ^ data_b ^ expected_data_b) &&
                expected_strobe_b === (expected_strobe_b ^ strobe_b ^ expected_strobe_b) &&
                expected_uart_dout === (expected_uart_dout ^ uart_dout ^ expected_uart_dout) &&
                expected_uart_wr === (expected_uart_wr ^ uart_wr ^ expected_uart_wr)) begin
                $display("PASS");
                $display("  Outputs: data_b=%h, strobe_b=%b, uart_dout=%h, uart_wr=%b",
                         data_b, strobe_b, uart_dout, uart_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_b=%h, strobe_b=%b, uart_dout=%h, uart_wr=%b",
                         expected_data_b, expected_strobe_b, expected_uart_dout, expected_uart_wr);
                $display("  Got:      data_b=%h, strobe_b=%b, uart_dout=%h, uart_wr=%b",
                         data_b, strobe_b, uart_dout, uart_wr);
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
        $dumpvars(0,addr_b, clk, data_b_in, data_b_we, rst, uart_din, uart_valid, data_b, strobe_b, uart_dout, uart_wr);
    end

endmodule
