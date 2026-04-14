`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg cf;
    reg clk;
    reg [7:0] op;
    wire [15:0] acc;
    wire [15:0] c;
    wire c_flag;
    wire o_flag;
    wire z_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cf(cf),
        .clk(clk),
        .op(op),
        .acc(acc),
        .c(c),
        .c_flag(c_flag),
        .o_flag(o_flag),
        .z_flag(z_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 16'h0;
            b <= 16'h0;
            cf <= 1'b0;
            op <= 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (0x1234 + 0x1111)", test_num);
            a <= 16'h1234;
            b <= 16'h1111;
            cf <= 1'b0;
            op <= OP_ADD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2345, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry-in (0x0001 + 0x0001 + CF=1)", test_num);
            a <= 16'h0001;
            b <= 16'h0001;
            cf <= 1'b1;
            op <= OP_ADD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Carry-out and Zero Flag (0xFFFF + 0x0001)", test_num);
            a <= 16'hFFFF;
            b <= 16'h0001;
            cf <= 1'b0;
            op <= OP_ADD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Signed Overflow (0x7FFF + 0x0001)", test_num);
            a <= 16'h7FFF;
            b <= 16'h0001;
            cf <= 1'b0;
            op <= OP_ADD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000, 16'h0000, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (0x0050 - 0x0010)", test_num);
            a <= 16'h0050;
            b <= 16'h0010;
            cf <= 1'b0;
            op <= OP_SUB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0040, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Large (0x8000 * 0x0004)", test_num);
            a <= 16'h8000;
            b <= 16'h0004;
            op <= OP_MUL;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0002, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication Small (0x000A * 0x0003)", test_num);
            a <= 16'h000A;
            b <= 16'h0003;
            op <= OP_MUL;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h001E, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Comparison (0x1234 == 0x1234)", test_num);
            a <= 16'h1234;
            b <= 16'h1234;
            op <= OP_CMP;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000, 1'b0, 1'b0, 1'b1);
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
        input [15:0] expected_acc;
        input [15:0] expected_c;
        input expected_c_flag;
        input expected_o_flag;
        input expected_z_flag;
        begin
            if (expected_acc === (expected_acc ^ acc ^ expected_acc) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_c_flag === (expected_c_flag ^ c_flag ^ expected_c_flag) &&
                expected_o_flag === (expected_o_flag ^ o_flag ^ expected_o_flag) &&
                expected_z_flag === (expected_z_flag ^ z_flag ^ expected_z_flag)) begin
                $display("PASS");
                $display("  Outputs: acc=%h, c=%h, c_flag=%b, o_flag=%b, z_flag=%b",
                         acc, c, c_flag, o_flag, z_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acc=%h, c=%h, c_flag=%b, o_flag=%b, z_flag=%b",
                         expected_acc, expected_c, expected_c_flag, expected_o_flag, expected_z_flag);
                $display("  Got:      acc=%h, c=%h, c_flag=%b, o_flag=%b, z_flag=%b",
                         acc, c, c_flag, o_flag, z_flag);
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
        $dumpvars(0,a, b, cf, clk, op, acc, c, c_flag, o_flag, z_flag);
    end

endmodule
