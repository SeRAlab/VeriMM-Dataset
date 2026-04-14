`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg rst;
    reg s0;
    reg s1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .rst(rst),
        .s0(s0),
        .s1(s1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            s0 = 0; s1 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in0 = 8'hA5; in1 = 8'hFF; in2 = 8'h00; in3 = 8'h55;
            s1 = 0; s0 = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in0 = 8'h00; in1 = 8'h5A; in2 = 8'hFF; in3 = 8'hAA;
            s1 = 0; s0 = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in0 = 8'h11; in1 = 8'h22; in2 = 8'h33; in3 = 8'h44;
            s1 = 1; s0 = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in0 = 8'hDE; in1 = 8'hAD; in2 = 8'hBE; in3 = 8'hEF;
            s1 = 1; s0 = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(8'hEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in3 = 8'hFF;
            s1 = 1; s0 = 1;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            s1 = 1; s0 = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in0 = 8'hFF;
            s1 = 0; s0 = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(8'hFF);
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
        $dumpvars(0,clk, in0, in1, in2, in3, rst, s0, s1, out);
    end

endmodule
