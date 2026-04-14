`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg reset;
    reg [1:0] sel;
    wire [31:0] falling_edge_detection;
    wire [31:0] out;

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
        .reset(reset),
        .sel(sel),
        .falling_edge_detection(falling_edge_detection),
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
            in0 = 32'h0;
            in1 = 32'h0;
            in2 = 32'h0;
            in3 = 32'h0;
            sel = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in0 = 32'hAAAA_BBBB;
            sel = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in1 = 32'hFFFF_FFFF;
            sel = 2'b01;
            @(posedge clk);
            #1;
            in1 = 32'hFFFF_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_FFFF, 32'hFFFF_0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in0 = 32'hF0F0_F0F0;
            in2 = 32'h0F0F_0F0F;
            sel = 2'b00;
            @(posedge clk);
            #1;
            sel = 2'b10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hF0F0_F0F0, 32'h0F0F_0F0F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in3 = 32'hDEADBEEF;
            sel = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in1 = 32'hDEADBEEF;
            sel = 2'b01;
            @(posedge clk);
            #1;
            in1 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in0 = 32'hFFFF_FFFF;
            sel = 2'b00;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 32'hFFFF_FFFF);
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
        input [31:0] expected_falling_edge_detection;
        input [31:0] expected_out;
        begin
            if (expected_falling_edge_detection === (expected_falling_edge_detection ^ falling_edge_detection ^ expected_falling_edge_detection) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: falling_edge_detection=%h, out=%h",
                         falling_edge_detection, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: falling_edge_detection=%h, out=%h",
                         expected_falling_edge_detection, expected_out);
                $display("  Got:      falling_edge_detection=%h, out=%h",
                         falling_edge_detection, out);
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
        $dumpvars(0,clk, in0, in1, in2, in3, reset, sel, falling_edge_detection, out);
    end

endmodule
