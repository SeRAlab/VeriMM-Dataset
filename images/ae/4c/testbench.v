`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg reset;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
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
            enable = 0;
            sel = 2'b00;
            in0 = 4'h0; in1 = 4'h0; in2 = 4'h0; in3 = 4'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Active Priority", test_num);
            reset_dut();
            reset = 1;
            enable = 1;
            sel = 2'b00;
            in0 = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Deasserted", test_num);
            reset_dut();
            reset = 0;
            enable = 0;
            sel = 2'b01;
            in1 = 4'hB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Input 0", test_num);
            reset_dut();
            reset = 0;
            enable = 1;
            sel = 2'b00;
            in0 = 4'h5; in1 = 4'hF; in2 = 4'hF; in3 = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Input 1", test_num);
            reset_dut();
            reset = 0;
            enable = 1;
            sel = 2'b01;
            in0 = 4'hF; in1 = 4'hE; in2 = 4'hF; in3 = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Input 2", test_num);
            reset_dut();
            reset = 0;
            enable = 1;
            sel = 2'b10;
            in0 = 4'hF; in1 = 4'hF; in2 = 4'hC; in3 = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Input 3", test_num);
            reset_dut();
            reset = 0;
            enable = 1;
            sel = 2'b11;
            in0 = 4'hF; in1 = 4'hF; in2 = 4'hF; in3 = 4'h9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset vs Enable Priority", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b10;
            in2 = 4'h7;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Input Data Update", test_num);
            reset_dut();
            enable = 1;
            sel = 2'b00;
            in0 = 4'h1;
            @(posedge clk);
            #1;
            in0 = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h2);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, enable, in0, in1, in2, in3, reset, sel, out);
    end

endmodule
