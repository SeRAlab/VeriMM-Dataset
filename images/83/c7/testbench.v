`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    reg sel_b1;
    reg sel_b2;
    wire [5:0] out_not;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_not(out_not),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 3'b000;
            b = 3'b000;
            sel_b1 = 1'b0;
            sel_b2 = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR selection", test_num);
            a = 3'b101;
            b = 3'b011;
            sel_b1 = 1'b0;





            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h07, 3'h7, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical OR selection", test_num);
            a = 3'b101;
            b = 3'b011;
            sel_b1 = 1'b1;





            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h31, 3'h7, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zeros inputs", test_num);
            a = 3'b000;
            b = 3'b000;
            sel_b1 = 1'b0;





            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h38, 3'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical selection with zeros", test_num);
            a = 3'b000;
            b = 3'b000;
            sel_b1 = 1'b1;





            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h38, 3'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed bit patterns", test_num);
            a = 3'b010;
            b = 3'b100;
            sel_b1 = 1'b0;





            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h0E, 3'h6, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones bitwise", test_num);
            a = 3'b111;
            b = 3'b111;
            sel_b1 = 1'b0;





            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h07, 3'h7, 1'b1);
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
        input [5:0] expected_out_not;
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        begin
            if (expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical)) begin
                $display("PASS");
                $display("  Outputs: out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         out_not, out_or_bitwise, out_or_logical);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         expected_out_not, expected_out_or_bitwise, expected_out_or_logical);
                $display("  Got:      out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         out_not, out_or_bitwise, out_or_logical);
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
        $dumpvars(0,a, b, clk, sel_b1, sel_b2, out_not, out_or_bitwise, out_or_logical);
    end

endmodule
