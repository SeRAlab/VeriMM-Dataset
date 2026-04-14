`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] add_in;
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg reset;
    reg [2:0] sel;
    reg select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_in(add_in),
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .reset(reset),
        .sel(sel),
        .select(select),
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
            sel = 0;
            data0 = 0; data1 = 0; data2 = 0; data3 = 0; data4 = 0; data5 = 0;
            add_in = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            data0 = 4'hF; sel = 3'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data0 = 4'hA;
            sel = 3'd0;
            select = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data3 = 4'h5;
            sel = 3'd3;
            select = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data1 = 4'h7;
            sel = 3'd1;
            add_in = 2'd2;
            select = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h09);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data5 = 4'hF;
            sel = 3'd5;
            add_in = 2'd3;
            select = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data2 = 4'h8;
            sel = 3'd2;
            add_in = 2'd3;
            select = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h08);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data4 = 4'h3;
            sel = 3'd4;
            add_in = 2'd1;
            select = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h04);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data0 = 4'h1;
            sel = 3'd0;
            select = 0;
            @(posedge clk);
            #1;
            data0 = 4'hE;
            #2;
            #1;

            check_outputs(8'h01);
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
        $dumpvars(0,add_in, clk, data0, data1, data2, data3, data4, data5, reset, sel, select, out);
    end

endmodule
