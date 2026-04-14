`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg clk;
    reg [3:0] d;
    reg rst;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .rst(rst),
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
            a = 0; b = 0; c = 0; d = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset behavior", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity (1*1*1*1)", test_num);
            reset_dut();
            a = 4'd1; b = 4'd1; c = 4'd1; d = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple product (2*3*2*2)", test_num);
            reset_dut();
            a = 4'd2; b = 4'd3; c = 4'd2; d = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd24);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero property (15*15*15*0)", test_num);
            reset_dut();
            a = 4'd15; b = 4'd15; c = 4'd15; d = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large result truncation (10^4)", test_num);
            reset_dut();
            a = 4'd10; b = 4'd10; c = 4'd10; d = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max inputs truncation (15^4)", test_num);
            reset_dut();
            a = 4'hF; b = 4'hF; c = 4'hF; d = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 (2*4*8*2)", test_num);
            reset_dut();
            a = 4'd2; b = 4'd4; c = 4'd8; d = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128);
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
        $dumpvars(0,a, b, c, clk, d, rst, out);
    end

endmodule
