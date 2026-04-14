`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_in_sign;
    reg data_valid;
    reg rst_n;
    wire data_ok;
    wire [7:0] data_out;
    wire data_out_sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_in_sign(data_in_sign),
        .data_valid(data_valid),
        .rst_n(rst_n),
        .data_ok(data_ok),
        .data_out(data_out),
        .data_out_sign(data_out_sign)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            data_in_sign = 0;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            repeat(8) begin
                @(negedge clk);
                data_in = 8'd3;
                data_in_sign = 1;
                data_valid = 1;
            end

            data_in = 8'd7;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd28, 1'b0);
            @(negedge clk) data_valid = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat(8) begin
                @(negedge clk);
                data_in = 8'd4;
                data_in_sign = 1;
                data_valid = 1;
            end

            data_in = 8'd8;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd36, 1'b0);
            @(negedge clk) data_valid = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(8) begin
                @(negedge clk);
                data_in = 8'd1;
                data_in_sign = 1;
                data_valid = 1;
            end
            @(posedge clk);

            #1;


            check_outputs(1'b0, 8'd8, 1'b0);
            @(negedge clk) data_valid = 0;
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            for (i=0; i<8; i=i+1) begin
                @(negedge clk);
                data_valid = 1;
                if (i < 4) begin
                    data_in = 8'd7;
                    data_in_sign = 1;
                end else begin
                    data_in = 8'd100;
                    data_in_sign = 0;
                end
            end
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd28, 1'b0);
            @(negedge clk) data_valid = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            repeat(4) begin
                @(negedge clk);
                data_in = 8'd3; data_in_sign = 1; data_valid = 1;
            end
            data_in = 8'd2;

            repeat(5) begin
                @(negedge clk);
                data_in = 8'd50; data_in_sign = 1; data_valid = 0;
            end

            repeat(4) begin
                @(negedge clk);
                data_in = 8'd4; data_in_sign = 1; data_valid = 1;
            end
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd28, 1'b0);
            @(negedge clk) data_valid = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            repeat(4) begin
                @(negedge clk);
                data_in = 8'd10; data_in_sign = 1; data_valid = 1;
            end

            @(negedge clk);
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;

            repeat(8) begin
                @(negedge clk);
                data_in = 8'd4; data_in_sign = 1; data_valid = 1;
            end
            data_in = 8'd8;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd36, 1'b0);
            @(negedge clk) data_valid = 0;
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
        input expected_data_ok;
        input [7:0] expected_data_out;
        input expected_data_out_sign;
        begin
            if (expected_data_ok === (expected_data_ok ^ data_ok ^ expected_data_ok) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_sign === (expected_data_out_sign ^ data_out_sign ^ expected_data_out_sign)) begin
                $display("PASS");
                $display("  Outputs: data_ok=%b, data_out=%h, data_out_sign=%b",
                         data_ok, data_out, data_out_sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ok=%b, data_out=%h, data_out_sign=%b",
                         expected_data_ok, expected_data_out, expected_data_out_sign);
                $display("  Got:      data_ok=%b, data_out=%h, data_out_sign=%b",
                         data_ok, data_out, data_out_sign);
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
        $dumpvars(0,clk, data_in, data_in_sign, data_valid, rst_n, data_ok, data_out, data_out_sign);
    end

endmodule
