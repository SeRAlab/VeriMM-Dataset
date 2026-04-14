`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d0;
    reg [7:0] d1;
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg [7:0] data4;
    reg [7:0] data5;
    reg reset;
    reg [2:0] sel;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d0(d0),
        .d1(d1),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .reset(reset),
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
            @(posedge clk);
            reset = 1;

            d0 = 8'h00; d1 = 8'h00;
            data0 = 8'h00; data1 = 8'h00; data2 = 8'h00;
            data3 = 8'h00; data4 = 8'h00; data5 = 8'h00;
            sel = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Reset Register 0 Check");
            reset_dut();
            sel = 3'd0;
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Reset Register 1 Check");
            reset_dut();
            sel = 3'd1;
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Update and Select Register 0");
            reset_dut();
            d0 = 8'hA5;
            sel = 3'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Update and Select Register 1");
            reset_dut();
            d1 = 8'h5A;
            sel = 3'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Select data0");
            reset_dut();
            data0 = 8'h11;
            sel = 3'd2;
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Select data1");
            reset_dut();
            data1 = 8'h22;
            sel = 3'd3;
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Select data2");
            reset_dut();
            data2 = 8'h33;
            sel = 3'd4;
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Select data3");
            reset_dut();
            data3 = 8'h44;
            sel = 3'd5;
            #2;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase009;

        begin
            $display("Test 009: Select data4");
            reset_dut();
            data4 = 8'h55;
            sel = 3'd6;
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase010;

        begin
            $display("Test 010: Select data5");
            reset_dut();
            data5 = 8'h66;
            sel = 3'd7;
            #2;
            #1;

            check_outputs(8'h66);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d0, d1, data0, data1, data2, data3, data4, data5, reset, sel, q);
    end

endmodule
