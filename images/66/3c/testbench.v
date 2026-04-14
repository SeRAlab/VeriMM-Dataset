`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg [2:0] select;
    wire [7:0] data_out;
    wire [7:0] debug;
    wire [2:0] output_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .select(select),
        .data_out(data_out),
        .debug(debug),
        .output_sel(output_sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            select = 3'b000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 8'hAA;
            select = 3'b000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA, 8'h00, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 8'hF0;
            select = 3'b001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h0F, 8'h00, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 8'h01;
            select = 3'b010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h02, 8'h00, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 8'h80;
            select = 3'b011;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h40, 8'h00, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 8'h55;
            select = 3'b100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55, 8'h55, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            data_in = 8'hFF;
            select = 3'b000;
            @(posedge clk);
            #2;

            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;

            #1;


            check_outputs(8'h00, 8'h00, 3'b000);
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
        input [7:0] expected_data_out;
        input [7:0] expected_debug;
        input [2:0] expected_output_sel;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_debug === (expected_debug ^ debug ^ expected_debug) &&
                expected_output_sel === (expected_output_sel ^ output_sel ^ expected_output_sel)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, debug=%h, output_sel=%h",
                         data_out, debug, output_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, debug=%h, output_sel=%h",
                         expected_data_out, expected_debug, expected_output_sel);
                $display("  Got:      data_out=%h, debug=%h, output_sel=%h",
                         data_out, debug, output_sel);
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
        $dumpvars(0,clk, data_in, rst, select, data_out, debug, output_sel);
    end

endmodule
