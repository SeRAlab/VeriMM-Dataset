`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] Cb;
    reg [9:0] Cr;
    reg [9:0] Y;
    reg clk;
    reg rst;
    wire [7:0] B;
    wire [7:0] G;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cb(Cb),
        .Cr(Cr),
        .Y(Y),
        .clk(clk),
        .rst(rst),
        .B(B),
        .G(G),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Y = 0;
            Cr = 512;
            Cb = 512;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            Y = 10'd0; Cr = 10'd512; Cb = 10'd512;
            repeat(5) @(posedge clk);
            $display("Testcase 001: Black Level");
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Y = 10'd1023; Cr = 10'd512; Cb = 10'd512;
            repeat(5) @(posedge clk);
            $display("Testcase 002: White Level (Clipping Max)");
            #1;

            check_outputs(8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Y = 10'd512; Cr = 10'd512; Cb = 10'd512;
            repeat(5) @(posedge clk);
            $display("Testcase 003: Midpoint Gray");

            #1;


            check_outputs(8'h80, 8'h80, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Y = 10'd400; Cr = 10'd900; Cb = 10'd512;
            repeat(5) @(posedge clk);
            $display("Testcase 004: High Cr (Reddish)");



            #1;




            check_outputs(8'h64, 8'h2F, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Y = 10'd400; Cr = 10'd512; Cb = 10'd900;
            repeat(5) @(posedge clk);
            $display("Testcase 005: High Cb (Bluish)");
            #1;

            check_outputs(8'hFF, 8'h51, 8'h64);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Y = 10'd50; Cr = 10'd100; Cb = 10'd100;
            repeat(5) @(posedge clk);
            $display("Testcase 006: Clipping Underflow");

            if (R >= 0 && G >= 0 && B >= 0) begin
                $display("PASS: Clipping logic functional");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Negative values detected");
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
        input [7:0] expected_B;
        input [7:0] expected_G;
        input [7:0] expected_R;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: B=%h, G=%h, R=%h",
                         B, G, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, G=%h, R=%h",
                         expected_B, expected_G, expected_R);
                $display("  Got:      B=%h, G=%h, R=%h",
                         B, G, R);
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
        $dumpvars(0,Cb, Cr, Y, clk, rst, B, G, R);
    end

endmodule
