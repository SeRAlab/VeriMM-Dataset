`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [1:0] ready;
    reg rst;
    reg [23:0] size;
    wire [1:0] activate;
    wire [31:0] data;
    wire strobe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .ready(ready),
        .rst(rst),
        .size(size),
        .activate(activate),
        .data(data),
        .strobe(strobe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            ready = 2'b00;
            size = 24'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(2'b00, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            size = 24'd100;
            ready = 2'b01;
            enable = 1;

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 32'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            size = 24'd100;
            ready = 2'b10;
            enable = 1;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 32'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            size = 24'd3;
            ready = 2'b01;
            enable = 1;

            repeat(5) @(posedge clk);
            #1;






            #1;







            check_outputs(2'b01, 32'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            size = 24'd100;
            ready = 2'b11;
            enable = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 32'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            size = 24'd50;
            ready = 2'b01;
            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            size = 24'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 32'd1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            size = 24'd100;
            ready = 2'b01;
            enable = 1;
            repeat(3) @(posedge clk);
            #1;
            enable = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 32'd0, 1'b0);
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
        testcase007();
        
        
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
        input [1:0] expected_activate;
        input [31:0] expected_data;
        input expected_strobe;
        begin
            if (expected_activate === (expected_activate ^ activate ^ expected_activate) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_strobe === (expected_strobe ^ strobe ^ expected_strobe)) begin
                $display("PASS");
                $display("  Outputs: activate=%h, data=%h, strobe=%b",
                         activate, data, strobe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: activate=%h, data=%h, strobe=%b",
                         expected_activate, expected_data, expected_strobe);
                $display("  Got:      activate=%h, data=%h, strobe=%b",
                         activate, data, strobe);
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
        $dumpvars(0,clk, enable, ready, rst, size, activate, data, strobe);
    end

endmodule
