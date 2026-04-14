`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] bin;
    reg clk;
    reg [2:0] gin;
    reg [2:0] rin;
    wire [1:0] bout;
    wire [2:0] gout;
    wire [10:0] hc;
    wire hs;
    wire [2:0] rout;
    wire [10:0] vc;
    wire vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .gin(gin),
        .rin(rin),
        .bout(bout),
        .gout(gout),
        .hc(hc),
        .hs(hs),
        .rout(rout),
        .vc(vc),
        .vs(vs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rin = 3'b000;
            gin = 3'b000;
            bin = 2'b00;

            wait(hc == 0 && vc == 0);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            rin = 3'b111; gin = 3'b010; bin = 2'b01;


            wait(vc == 100);
            wait(hc == 100);
            @(posedge clk);
            #1;

            $display("Testcase 001: Active Video Area (100, 100)");

            #1;


            check_outputs(2'b01, 3'b010, 11'd100, 1'b1, 3'b111, 11'd100, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            rin = 3'b111; gin = 3'b111; bin = 2'b11;

            wait(vc == 10);
            wait(hc == 650);
            @(posedge clk);
            #1;

            $display("Testcase 002: Horizontal Front Porch (650, 10)");

            #1;


            check_outputs(2'b00, 3'b000, 11'd650, 1'b1, 3'b000, 11'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            rin = 3'b101; gin = 3'b110; bin = 2'b11;

            wait(vc == 10);
            wait(hc == 700);
            @(posedge clk);
            #1;

            $display("Testcase 003: Horizontal Sync Pulse (700, 10)");

            #1;


            check_outputs(2'b00, 3'b000, 11'd700, 1'b0, 3'b000, 11'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            rin = 3'b111; gin = 3'b111; bin = 2'b11;

            wait(vc == 485);
            wait(hc == 10);
            @(posedge clk);
            #1;

            $display("Testcase 004: Vertical Front Porch (10, 485)");

            #1;


            check_outputs(2'b00, 3'b000, 11'd10, 1'b1, 3'b000, 11'd485, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            rin = 3'b100; gin = 3'b100; bin = 2'b10;

            wait(vc == 491);
            wait(hc == 10);
            @(posedge clk);
            #1;

            $display("Testcase 005: Vertical Sync Pulse (10, 491)");

            #1;


            check_outputs(2'b00, 3'b000, 11'd10, 1'b1, 3'b000, 11'd491, 1'b0);
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
        input [1:0] expected_bout;
        input [2:0] expected_gout;
        input [10:0] expected_hc;
        input expected_hs;
        input [2:0] expected_rout;
        input [10:0] expected_vc;
        input expected_vs;
        begin
            if (expected_bout === (expected_bout ^ bout ^ expected_bout) &&
                expected_gout === (expected_gout ^ gout ^ expected_gout) &&
                expected_hc === (expected_hc ^ hc ^ expected_hc) &&
                expected_hs === (expected_hs ^ hs ^ expected_hs) &&
                expected_rout === (expected_rout ^ rout ^ expected_rout) &&
                expected_vc === (expected_vc ^ vc ^ expected_vc) &&
                expected_vs === (expected_vs ^ vs ^ expected_vs)) begin
                $display("PASS");
                $display("  Outputs: bout=%h, gout=%h, hc=%h, hs=%b, rout=%h, vc=%h, vs=%b",
                         bout, gout, hc, hs, rout, vc, vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bout=%h, gout=%h, hc=%h, hs=%b, rout=%h, vc=%h, vs=%b",
                         expected_bout, expected_gout, expected_hc, expected_hs, expected_rout, expected_vc, expected_vs);
                $display("  Got:      bout=%h, gout=%h, hc=%h, hs=%b, rout=%h, vc=%h, vs=%b",
                         bout, gout, hc, hs, rout, vc, vs);
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
        $dumpvars(0,bin, clk, gin, rin, bout, gout, hc, hs, rout, vc, vs);
    end

endmodule
