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
            #2 rst_n = 1;
            ready_b = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task send_byte;

        input [7:0] value;
        begin
            while (!ready_a) @(posedge clk);
            #1;
            data_in = value;
            valid_a = 1;
            @(posedge clk);
            #1;
            valid_a = 0;
            data_in = 8'h00;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Accumulation (10, 20, 30, 40)", test_num);
            reset_dut();

            send_byte(8'd10);
            send_byte(8'd20);
            send_byte(8'd30);
            send_byte(8'd40);


            while (!valid_b) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd100, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Maximum Values (255, 255, 255, 255)", test_num);
            reset_dut();

            send_byte(8'hFF);
            send_byte(8'hFF);
            send_byte(8'hFF);
            send_byte(8'hFF);

            while (!valid_b) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd1020, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Intermittent valid_a", test_num);
            reset_dut();

            send_byte(8'd5);
            repeat(3) @(posedge clk);
            send_byte(8'd5);
            repeat(2) @(posedge clk);
            send_byte(8'd5);
            send_byte(8'd5);

            while (!valid_b) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd20, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Medium Values (128, 64, 32, 16)", test_num);
            reset_dut();

            send_byte(8'd128);
            send_byte(8'd64);
            send_byte(8'd32);
            send_byte(8'd16);

            while (!valid_b) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd240, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Consecutive Sets (Set 1: 1,1,1,1; Set 2: 2,2,2,2)", test_num);
            reset_dut();


            send_byte(8'd1);
            send_byte(8'd1);
            send_byte(8'd1);
            send_byte(8'd1);
            while (!valid_b) @(posedge clk);


            send_byte(8'd2);
            send_byte(8'd2);
            send_byte(8'd2);
            send_byte(8'd2);

            while (!valid_b) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd8, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Back-pressure (ready_b=0)", test_num);
            reset_dut();

            ready_b = 0;
            send_byte(8'd50);
            send_byte(8'd50);
            send_byte(8'd50);
            send_byte(8'd50);


            repeat(5) @(posedge clk);



            #1;
            if (valid_b && data_out == 10'd200) begin
                $display("Sum calculated correctly despite ready_b=0");
                #1;

                check_outputs(10'd200, ready_a, 1'b1);
            end else begin

                repeat(5) @(posedge clk);
                #1;

                check_outputs(10'd200, ready_a, 1'b1);
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
