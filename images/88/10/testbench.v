`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [254:0] in;
    reg reset;
    reg [2:0] vec;
    wire o0;
    wire o1;
    wire o2;
    wire [10:0] out;
    wire [2:0] outv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out(out),
        .outv(outv)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            vec = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 11'h000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            vec = 3'b101;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 11'h02D, 3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 255;
            vec = 3'b111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 11'h7FF, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 255;
            @(posedge clk);
            #1;
            in = 0;
            vec = 3'b010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 11'h002, 3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            vec = 3'b001;
            repeat(128) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 11'h401, 3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 255'hFFFF_FFFF;
            vec = 3'b110;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 11'h056, 3'b110);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [10:0] expected_out;
        input [2:0] expected_outv;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_outv === (expected_outv ^ outv ^ expected_outv)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, out=%h, outv=%h",
                         o0, o1, o2, out, outv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, out=%h, outv=%h",
                         expected_o0, expected_o1, expected_o2, expected_out, expected_outv);
                $display("  Got:      o0=%b, o1=%b, o2=%b, out=%h, outv=%h",
                         o0, o1, o2, out, outv);
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
        $dumpvars(0,clk, in, reset, vec, o0, o1, o2, out, outv);
    end

endmodule
