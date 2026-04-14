`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg b_in;
    reg clk;
    reg clk_16;
    reg clk_16_en;
    reg g_in;
    reg hs_in;
    reg r_in;
    reg scanlines;
    reg vs_in;
    wire [1:0] b_out;
    wire [1:0] g_out;
    wire hs_out;
    wire is15k;
    wire [1:0] r_out;
    wire vs_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b_in(b_in),
        .clk(clk),
        .clk_16(clk_16),
        .clk_16_en(clk_16_en),
        .g_in(g_in),
        .hs_in(hs_in),
        .r_in(r_in),
        .scanlines(scanlines),
        .vs_in(vs_in),
        .b_out(b_out),
        .g_out(g_out),
        .hs_out(hs_out),
        .is15k(is15k),
        .r_out(r_out),
        .vs_out(vs_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            b_in = 0;
            g_in = 0;
            r_in = 0;
            hs_in = 1;
            vs_in = 1;
            scanlines = 0;
            repeat(10) @(posedge clk);
            $display("\nRunning Testcase %03d...", test_num);
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            repeat(5) begin
                hs_in = 0; repeat(100) @(posedge clk);
                hs_in = 1; repeat(400) @(posedge clk);
            end

            #1;


            check_outputs(2'b00, 2'b00, 1'b1, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();


            repeat(10) begin
                hs_in = 0; repeat(200) @(posedge clk);
                hs_in = 1; repeat(2000) @(posedge clk);
            end

            #1;


            check_outputs(2'b00, 2'b00, 1'b1, 1'b1, 2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            scanlines = 0;

            hs_in = 0; repeat(100) @(posedge clk);
            hs_in = 1;

            r_in = 1; g_in = 1; b_in = 1;
            repeat(50) @(posedge clk);



            #1;




            check_outputs(2'b11, 2'b11, 1'b1, 1'b1, 2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            scanlines = 1;

            repeat(3) begin
                hs_in = 0; repeat(100) @(posedge clk);
                hs_in = 1; repeat(500) @(posedge clk);
            end

            r_in = 1; g_in = 1; b_in = 1;
            repeat(20) @(posedge clk);


            #1;



            check_outputs(2'b01, 2'b01, 1'b1, 1'b1, 2'b01, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            vs_in = 0;
            repeat(1000) @(posedge clk);

            #1;


            check_outputs(2'b00, 2'b00, 1'b1, 1'b1, 2'b00, 1'b0);
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
        input [1:0] expected_b_out;
        input [1:0] expected_g_out;
        input expected_hs_out;
        input expected_is15k;
        input [1:0] expected_r_out;
        input expected_vs_out;
        begin
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_g_out === (expected_g_out ^ g_out ^ expected_g_out) &&
                expected_hs_out === (expected_hs_out ^ hs_out ^ expected_hs_out) &&
                expected_is15k === (expected_is15k ^ is15k ^ expected_is15k) &&
                expected_r_out === (expected_r_out ^ r_out ^ expected_r_out) &&
                expected_vs_out === (expected_vs_out ^ vs_out ^ expected_vs_out)) begin
                $display("PASS");
                $display("  Outputs: b_out=%h, g_out=%h, hs_out=%b, is15k=%b, r_out=%h, vs_out=%b",
                         b_out, g_out, hs_out, is15k, r_out, vs_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%h, g_out=%h, hs_out=%b, is15k=%b, r_out=%h, vs_out=%b",
                         expected_b_out, expected_g_out, expected_hs_out, expected_is15k, expected_r_out, expected_vs_out);
                $display("  Got:      b_out=%h, g_out=%h, hs_out=%b, is15k=%b, r_out=%h, vs_out=%b",
                         b_out, g_out, hs_out, is15k, r_out, vs_out);
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
        $dumpvars(0,b_in, clk, clk_16, clk_16_en, g_in, hs_in, r_in, scanlines, vs_in, b_out, g_out, hs_out, is15k, r_out, vs_out);
    end

endmodule
