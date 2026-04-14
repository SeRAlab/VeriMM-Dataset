`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] b_in;
    reg clk;
    reg [7:0] g_in;
    reg [7:0] r_in;
    reg rst;
    wire [7:0] b_out;
    wire [7:0] g_out;
    wire [7:0] r_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_in(b_in),
        .clk(clk),
        .g_in(g_in),
        .r_in(r_in),
        .rst(rst),
        .b_out(b_out),
        .g_out(g_out),
        .r_out(r_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            r_in = 0;
            g_in = 0;
            b_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard mid-range values", test_num);
            reset_dut();


            r_in = 8'd50;
            g_in = 8'd100;
            b_in = 8'd60;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd120, 8'd115, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum values and underflow", test_num);
            reset_dut();


            r_in = 8'd5;
            g_in = 8'd0;
            b_in = 8'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 8'd15, 8'd251);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum values and overflow", test_num);
            reset_dut();


            r_in = 8'd255;
            g_in = 8'd250;
            b_in = 8'd128;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 8'd9, 8'd245);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Blue channel boundary", test_num);
            reset_dut();


            r_in = 8'd10;
            g_in = 8'd240;
            b_in = 8'd200;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd144, 8'd255, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset state verification", test_num);


            r_in = 8'hAA;
            g_in = 8'hBB;
            b_in = 8'hCC;


            rst = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00);
            rst = 0;
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
        input [7:0] expected_b_out;
        input [7:0] expected_g_out;
        input [7:0] expected_r_out;
        begin
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_g_out === (expected_g_out ^ g_out ^ expected_g_out) &&
                expected_r_out === (expected_r_out ^ r_out ^ expected_r_out)) begin
                $display("PASS");
                $display("  Outputs: b_out=%h, g_out=%h, r_out=%h",
                         b_out, g_out, r_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%h, g_out=%h, r_out=%h",
                         expected_b_out, expected_g_out, expected_r_out);
                $display("  Got:      b_out=%h, g_out=%h, r_out=%h",
                         b_out, g_out, r_out);
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
        $dumpvars(0,b_in, clk, g_in, r_in, rst, b_out, g_out, r_out);
    end

endmodule
