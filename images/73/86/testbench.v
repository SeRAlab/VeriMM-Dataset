`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    reg [7:0] reset;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .q(q)
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
        reset = 8'hFF;
        #15;
        reset = 8'h00;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Bitwise and Logical OR operation", test_num);
        a = 3'b101;
        b = 3'b010;

        @(posedge clk);
        #2;

        #1;


        check_outputs(3'b111, 1'b1, 8'b10000111);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Input patterns where q[7] (combined AND) should be 0", test_num);
        a = 3'b100;
        b = 3'b000;
        @(posedge clk);
        #2;

        #1;


        check_outputs(3'b100, 1'b1, 8'b00000100);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: All zeros input", test_num);
        a = 3'b000;
        b = 3'b000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b000, 1'b0, 8'b00000000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Selective independent asynchronous reset", test_num);
        a = 3'b111;
        b = 3'b111;
        @(posedge clk);
        #2;
        reset = 8'b00000010;
        #2;

        #1;


        check_outputs(3'b111, 1'b1, 8'b10000101);
        reset = 8'h00;
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Resetting the highest bit of q independently", test_num);
        a = 3'b111;
        b = 3'b111;
        @(posedge clk);
        #2;
        reset = 8'b10000000;
        #2;

        #1;


        check_outputs(3'b111, 1'b1, 8'b00000111);
        reset = 8'h00;
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Verifying sequential storage timing", test_num);
        a = 3'b001;
        b = 3'b000;
        #2;

        if (out_or_bitwise === 3'b001 && q === 8'h00) begin
            a = 3'b011;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'b011, 1'b1, 8'b00000011);
        end else begin
            $display("FAIL: Initial q state incorrect before clock");
            fail_count = fail_count + 1;
        end
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
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        input [7:0] expected_q;
        begin
            if (expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_or_bitwise=%h, out_or_logical=%b, q=%h",
                         out_or_bitwise, out_or_logical, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or_bitwise=%h, out_or_logical=%b, q=%h",
                         expected_out_or_bitwise, expected_out_or_logical, expected_q);
                $display("  Got:      out_or_bitwise=%h, out_or_logical=%b, q=%h",
                         out_or_bitwise, out_or_logical, q);
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
        $dumpvars(0,a, b, clk, reset, out_or_bitwise, out_or_logical, q);
    end

endmodule
