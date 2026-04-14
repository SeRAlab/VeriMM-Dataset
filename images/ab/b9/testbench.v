`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg ena;
    reg load;
    reg rst;
    reg [2:0] sel;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .ena(ena),
        .load(load),
        .rst(rst),
        .sel(sel),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load = 0;
        ena = 0;
        sel = 0;
        data0 = 0; data1 = 0; data2 = 0; data3 = 0; data4 = 0; data5 = 0;
        #12;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Verifying Asynchronous Reset...");
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Load Data0 via Mux (sel=0)...");
        reset_dut();
        data0 = 4'hA;
        sel = 3'd0;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Load Data1 via Mux (sel=1)...");
        reset_dut();
        data1 = 4'h5;
        sel = 3'd1;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Load Data2 via Mux (sel=2)...");
        reset_dut();
        data2 = 4'hC;
        sel = 3'd2;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Load Data3 via Mux (sel=3)...");
        reset_dut();
        data3 = 4'h3;
        sel = 3'd3;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Load Data4 via Mux (sel=4)...");
        reset_dut();
        data4 = 4'hF;
        sel = 3'd4;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Load Data5 via Mux (sel=5)...");
        reset_dut();
        data5 = 4'h8;
        sel = 3'd5;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Verifying Reset Priority over Load...");
        reset_dut();
        data0 = 4'hF;
        sel = 3'd0;
        load = 1;
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Verifying Data Hold (load=0, ena=0)...");
        reset_dut();

        data0 = 4'hB;
        sel = 3'd0;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        ena = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Verifying Enable shifts the register...");
        reset_dut();

        data0 = 4'h1;
        sel = 3'd0;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        ena = 1;
        @(posedge clk);
        #1;

        if (q != 4'h1 && q != 4'h0) begin
            $display("PASS: Register shifted to %h", q);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Register did not shift or went to 0. Got: %h", q);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data0, data1, data2, data3, data4, data5, ena, load, rst, sel, q);
    end

endmodule
