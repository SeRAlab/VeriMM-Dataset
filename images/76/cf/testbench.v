`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    wire out_and_logical;
    wire [5:0] out_not;
    wire [2:0] out_xor_bitwise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out_and_logical(out_and_logical),
        .out_not(out_not),
        .out_xor_bitwise(out_xor_bitwise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 3'b0;
        b = 3'b0;


        @(posedge clk);
        @(posedge clk);
        #1;
    end
    endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 3'b000;
        b = 3'b000;

        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: All Zeros", test_num);
        #1;

        check_outputs(1'b0, 6'b111111, 3'b000);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 3'b111;
        b = 3'b111;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: All Ones", test_num);
        #1;

        check_outputs(1'b1, 6'b000000, 3'b000);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 3'b101;
        b = 3'b010;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Mixed Bits", test_num);
        #1;

        check_outputs(1'b1, 6'b101010, 3'b111);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 3'b000;
        b = 3'b111;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: One input zero", test_num);
        #1;

        check_outputs(1'b0, 6'b000111, 3'b111);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 3'b011;
        b = 3'b110;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: Bitwise XOR and NOT", test_num);
        #1;

        check_outputs(1'b1, 6'b001100, 3'b101);
    end
    endtask

    task testcase006;

    reg [2:0] a_vals [0:1];
    reg [2:0] b_vals [0:1];
    begin
        test_num = test_num + 1;
        reset_dut();

        a_vals[0] = 3'b100; b_vals[0] = 3'b100;
        a_vals[1] = 3'b001; b_vals[1] = 3'b001;


        a = a_vals[0]; b = b_vals[0];
        @(posedge clk);

        a = a_vals[1]; b = b_vals[1];
        @(posedge clk);

        #1;
        $display("Testcase %0d: Throughput check - Stage 1", test_num);

        #1;


        check_outputs(1'b1, 6'b011011, 3'b000);

        @(posedge clk);
        #1;
        $display("Testcase %0d: Throughput check - Stage 2", test_num);

        #1;


        check_outputs(1'b1, 6'b110110, 3'b000);
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
        input expected_out_and_logical;
        input [5:0] expected_out_not;
        input [2:0] expected_out_xor_bitwise;
        begin
            if (expected_out_and_logical === (expected_out_and_logical ^ out_and_logical ^ expected_out_and_logical) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor_bitwise === (expected_out_xor_bitwise ^ out_xor_bitwise ^ expected_out_xor_bitwise)) begin
                $display("PASS");
                $display("  Outputs: out_and_logical=%b, out_not=%h, out_xor_bitwise=%h",
                         out_and_logical, out_not, out_xor_bitwise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and_logical=%b, out_not=%h, out_xor_bitwise=%h",
                         expected_out_and_logical, expected_out_not, expected_out_xor_bitwise);
                $display("  Got:      out_and_logical=%b, out_not=%h, out_xor_bitwise=%h",
                         out_and_logical, out_not, out_xor_bitwise);
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
        $dumpvars(0,a, b, clk, out_and_logical, out_not, out_xor_bitwise);
    end

endmodule
