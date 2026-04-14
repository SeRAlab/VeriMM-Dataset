`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [1:0] format;
    reg rst;
    reg valid;
    wire [15:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .format(format),
        .rst(rst),
        .valid(valid),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 16'h0;
            format = 2'b00;
            valid = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            data_in = 16'hAAAA;
            format = 2'b00;
            valid = 1;
            @(posedge clk);
            valid = 0;




            #1;





            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            data_in = 16'h5555;
            format = 2'b01;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            data_in = 16'h1234;
            format = 2'b10;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            data_in = 16'hFFFF;
            format = 2'b00;
            valid = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            data_in = 16'h1111;
            format = 2'b00;
            valid = 1;
            @(posedge clk);
            data_in = 16'h2222;
            format = 2'b01;
            valid = 1;
            @(posedge clk);
            valid = 0;

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(posedge clk);
            data_in = 16'h3333;
            format = 2'b11;
            valid = 1;
            @(posedge clk);
            valid = 0;
            #1;

            check_outputs(data_out, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,clk, data_in, format, rst, valid, data_out, ready);
    end

endmodule
