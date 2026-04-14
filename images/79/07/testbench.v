`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] row0;
    reg [9:0] row1;
    reg rst;
    reg [65:0] v0;
    reg [65:0] v1;
    reg wr0;
    reg wr1;
    wire eof;
    wire push_to_adder;
    wire push_to_y;
    wire [9:0] row_to_adder;
    wire [65:0] v0_to_adder;
    wire [65:0] v1_to_adder;
    wire [65:0] v_to_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .row0(row0),
        .row1(row1),
        .rst(rst),
        .v0(v0),
        .v1(v1),
        .wr0(wr0),
        .wr1(wr1),
        .eof(eof),
        .push_to_adder(push_to_adder),
        .push_to_y(push_to_y),
        .row_to_adder(row_to_adder),
        .v0_to_adder(v0_to_adder),
        .v1_to_adder(v1_to_adder),
        .v_to_y(v_to_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr0 = 0;
            wr1 = 0;
            row0 = 0;
            row1 = 0;
            v0 = 0;
            v1 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            @(posedge clk);
            wr0 = 1;
            wr1 = 1;
            row0 = 10'd5;
            row1 = 10'd5;
            v0 = 66'h123456789ABCDEF01;
            v1 = 66'hFEDCBA9876543210F;
            @(posedge clk);
            wr0 = 0;
            wr1 = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 10'd5, 66'h123456789ABCDEF01, 66'hFEDCBA9876543210F, 66'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge clk);
            wr0 = 1;
            row0 = 10'd15;
            v0 = 66'hA5A5A5A5A5A5A5A5A;
            @(posedge clk);
            wr0 = 0;


            repeat(3) @(posedge clk);


            wr1 = 1;
            row1 = 10'd15;
            v1 = 66'h5A5A5A5A5A5A5A5A5;
            @(posedge clk);
            wr1 = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 10'd15, 66'hA5A5A5A5A5A5A5A5A, 66'h5A5A5A5A5A5A5A5A5, 66'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(posedge clk);
            wr0 = 1;
            row0 = 10'd20;
            v0 = 66'h1;
            wr1 = 1;
            row1 = 10'd21;
            v1 = 66'h2;
            @(posedge clk);
            wr0 = 0;
            wr1 = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 10'd0, 66'h0, 66'h0, 66'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            @(posedge clk);
            wr0 = 1; row0 = 10'd100; v0 = 66'hBEEF;
            wr1 = 1; row1 = 10'd100; v1 = 66'hDEAD;
            @(posedge clk);
            wr0 = 0; wr1 = 0;



            repeat(20) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0, 1'b1, 10'h0, 66'h0, 66'h0, 66'h0);
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
        input expected_eof;
        input expected_push_to_adder;
        input expected_push_to_y;
        input [9:0] expected_row_to_adder;
        input [65:0] expected_v0_to_adder;
        input [65:0] expected_v1_to_adder;
        input [65:0] expected_v_to_y;
        begin
            if (expected_eof === (expected_eof ^ eof ^ expected_eof) &&
                expected_push_to_adder === (expected_push_to_adder ^ push_to_adder ^ expected_push_to_adder) &&
                expected_push_to_y === (expected_push_to_y ^ push_to_y ^ expected_push_to_y) &&
                expected_row_to_adder === (expected_row_to_adder ^ row_to_adder ^ expected_row_to_adder) &&
                expected_v0_to_adder === (expected_v0_to_adder ^ v0_to_adder ^ expected_v0_to_adder) &&
                expected_v1_to_adder === (expected_v1_to_adder ^ v1_to_adder ^ expected_v1_to_adder) &&
                expected_v_to_y === (expected_v_to_y ^ v_to_y ^ expected_v_to_y)) begin
                $display("PASS");
                $display("  Outputs: eof=%b, push_to_adder=%b, push_to_y=%b, row_to_adder=%h, v0_to_adder=%h, v1_to_adder=%h, v_to_y=%h",
                         eof, push_to_adder, push_to_y, row_to_adder, v0_to_adder, v1_to_adder, v_to_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eof=%b, push_to_adder=%b, push_to_y=%b, row_to_adder=%h, v0_to_adder=%h, v1_to_adder=%h, v_to_y=%h",
                         expected_eof, expected_push_to_adder, expected_push_to_y, expected_row_to_adder, expected_v0_to_adder, expected_v1_to_adder, expected_v_to_y);
                $display("  Got:      eof=%b, push_to_adder=%b, push_to_y=%b, row_to_adder=%h, v0_to_adder=%h, v1_to_adder=%h, v_to_y=%h",
                         eof, push_to_adder, push_to_y, row_to_adder, v0_to_adder, v1_to_adder, v_to_y);
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
        $dumpvars(0,clk, row0, row1, rst, v0, v1, wr0, wr1, eof, push_to_adder, push_to_y, row_to_adder, v0_to_adder, v1_to_adder, v_to_y);
    end

endmodule
