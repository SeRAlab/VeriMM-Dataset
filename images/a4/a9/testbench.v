`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg ready_b;
    reg rst_n;
    reg valid_a;
    wire [9:0] data_out;
    wire ready_a;
    wire valid_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .ready_b(ready_b),
        .rst_n(rst_n),
        .valid_a(valid_a),
        .data_out(data_out),
        .ready_a(ready_a),
        .valid_b(valid_b)
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
            valid_a = 0;
            ready_b = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(10'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            data_in = 8'd100;
            valid_a = 1;
            @(posedge clk);
            valid_a = 0;

            #1;


            check_outputs(10'd100, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            data_in = 8'd50; valid_a = 1; ready_b = 1;
            @(posedge clk);

            data_in = 8'd75; valid_a = 1; ready_b = 1;
            @(posedge clk);
            valid_a = 0; ready_b = 0;

            #1;


            check_outputs(10'd125, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            repeat(4) begin
                @(posedge clk);
                data_in = 8'd250; valid_a = 1; ready_b = 1;
            end
            @(posedge clk);
            valid_a = 0; ready_b = 0;
            #1;

            check_outputs(10'd1000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            data_in = 8'd25; valid_a = 1;
            @(posedge clk);
            valid_a = 0;
            ready_b = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(10'd25, 1'b0, 1'b1);
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
        input [9:0] expected_data_out;
        input expected_ready_a;
        input expected_valid_b;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready_a === (expected_ready_a ^ ready_a ^ expected_ready_a) &&
                expected_valid_b === (expected_valid_b ^ valid_b ^ expected_valid_b)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready_a=%b, valid_b=%b",
                         data_out, ready_a, valid_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready_a=%b, valid_b=%b",
                         expected_data_out, expected_ready_a, expected_valid_b);
                $display("  Got:      data_out=%h, ready_a=%b, valid_b=%b",
                         data_out, ready_a, valid_b);
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
        $dumpvars(0,clk, data_in, ready_b, rst_n, valid_a, data_out, ready_a, valid_b);
    end

endmodule
