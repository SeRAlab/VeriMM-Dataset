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
    reg [7:0] in;
    reg reset;
    wire [3:0] out;
    wire [2:0] select;

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
        .in(in),
        .reset(reset),
        .out(out),
        .select(select)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 8'h00;
            data0 = 4'h0; data1 = 4'h1; data2 = 4'h2;
            data3 = 4'h3; data4 = 4'h4; data5 = 4'h5;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data0 = 4'hA;
            @(posedge clk);
            #1;

            check_outputs(4'hA, 3'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data1 = 4'hB;
            @(posedge clk);
            in = 8'h01;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(4'hB, 3'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data2 = 4'hC;
            @(posedge clk);
            in = 8'hFF;
            @(posedge clk);
            in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(4'hC, 3'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data3 = 4'hD;
            @(posedge clk);
            in = 8'h01;
            @(posedge clk);
            in = 8'h03;
            @(posedge clk);
            in = 8'h07;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(4'hD, 3'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data1 = 4'hE;
            @(posedge clk);
            in = 8'hAA;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(4'hE, 3'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data5 = 4'hF;
            @(posedge clk);
            in = 8'h01; @(posedge clk);
            in = 8'h00; @(posedge clk);
            in = 8'h02; @(posedge clk);
            in = 8'h00; @(posedge clk);
            in = 8'h04; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(4'hF, 3'd5);
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
        input [3:0] expected_out;
        input [2:0] expected_select;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_select === (expected_select ^ select ^ expected_select)) begin
                $display("PASS");
                $display("  Outputs: out=%h, select=%h",
                         out, select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, select=%h",
                         expected_out, expected_select);
                $display("  Got:      out=%h, select=%h",
                         out, select);
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
        $dumpvars(0,clk, data0, data1, data2, data3, data4, data5, in, reset, out, select);
    end

endmodule
