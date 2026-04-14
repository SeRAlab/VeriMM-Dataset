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
    reg reset;
    reg [2:0] sel;
    wire [7:0] out;

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
        .reset(reset),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data0 = 0; data1 = 0; data2 = 0;
            data3 = 0; data4 = 0; data5 = 0;
            sel = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data0 = 4'hA;
            sel = 3'd0;
            #1;

            #1;


            check_outputs(8'hA0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data0 = 4'h1;
            @(posedge clk);
            #1;
            sel = 3'd1;
            data1 = 4'hB;

            #1;


            check_outputs(8'hB1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            data0 = 4'h1; @(posedge clk); #1;

            data0 = 4'h0; @(posedge clk); #1;

            data0 = 4'hF; @(posedge clk); #1;

            sel = 3'd2;
            data2 = 4'hC;


            #1;



            check_outputs(8'hC5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data0=4'h0; data1=4'h1; data2=4'h2; data3=4'h3; data4=4'h4; data5=4'h5;

            sel = 3'd5;
            #1;

            #1;


            check_outputs(8'h50);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data0 = 4'h1; @(posedge clk); #1;
            data0 = 4'h1; @(posedge clk); #1;
            data0 = 4'h0; @(posedge clk); #1;
            data0 = 4'h1; @(posedge clk); #1;

            sel = 3'd4;
            data4 = 4'h9;

            #1;


            check_outputs(8'h95);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, data0, data1, data2, data3, data4, data5, reset, sel, out);
    end

endmodule
