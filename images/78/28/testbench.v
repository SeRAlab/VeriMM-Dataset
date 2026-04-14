`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
    reg sel;
    wire [3:0] out;
    wire [3:0] out_a;
    wire [3:0] out_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .out(out),
        .out_a(out_a),
        .out_b(out_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        A = 4'd0;
        B = 4'd0;
        sel = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Reset State Verification", test_num);
        reset = 1;
        A = 4'hF; B = 4'hA; sel = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h0, 4'h0, 4'h0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select A (sel=0)", test_num);
        reset_dut();
        A = 4'h5;
        B = 4'hE;
        sel = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h5, 4'h5, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Select B (sel=1)", test_num);
        reset_dut();
        A = 4'h5;
        B = 4'hE;
        sel = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hE, 4'h0, 4'hE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Boundary Check Select A (4'hF)", test_num);
        reset_dut();
        A = 4'hF;
        B = 4'h0;
        sel = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF, 4'hF, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Boundary Check Select B (4'hF)", test_num);
        reset_dut();
        A = 4'h0;
        B = 4'hF;
        sel = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hF, 4'h0, 4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating A input with sel=0", test_num);
        reset_dut();
        A = 4'hA;
        B = 4'h5;
        sel = 0;
        @(posedge clk);

        A = 4'h3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h3, 4'h3, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating B input with sel=1", test_num);
        reset_dut();
        A = 4'h3;
        B = 4'hC;
        sel = 1;
        @(posedge clk);

        B = 4'h9;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'h9, 4'h0, 4'h9);
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
        input [3:0] expected_out;
        input [3:0] expected_out_a;
        input [3:0] expected_out_b;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_a === (expected_out_a ^ out_a ^ expected_out_a) &&
                expected_out_b === (expected_out_b ^ out_b ^ expected_out_b)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_a=%h, out_b=%h",
                         out, out_a, out_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_a=%h, out_b=%h",
                         expected_out, expected_out_a, expected_out_b);
                $display("  Got:      out=%h, out_a=%h, out_b=%h",
                         out, out_a, out_b);
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
        $dumpvars(0,A, B, clk, reset, sel, out, out_a, out_b);
    end

endmodule
