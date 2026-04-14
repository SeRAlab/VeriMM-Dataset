`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire [4:0] c;
    wire co;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .c(c),
        .co(co)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'd0;
            b = 4'd0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (5 + 3)", test_num);
            a = 4'd5;
            b = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd8, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Out Generation (10 + 10)", test_num);
            a = 4'd10;
            b = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd20, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Carry Chaining", test_num);


            a = 4'd15;
            b = 4'd1;
            @(posedge clk);
            #1;


            a = 4'd2;
            b = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Sum (15 + 15 + Carry)", test_num);


            a = 4'd8;
            b = 4'd8;
            @(posedge clk);
            #1;


            a = 4'd15;
            b = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Add zeros with previous carry", test_num);


            a = 4'd15;
            b = 4'd15;
            @(posedge clk);
            #1;


            a = 4'd0;
            b = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1, 1'b0);
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
        input [4:0] expected_c;
        input expected_co;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_co === (expected_co ^ co ^ expected_co)) begin
                $display("PASS");
                $display("  Outputs: c=%h, co=%b",
                         c, co);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, co=%b",
                         expected_c, expected_co);
                $display("  Got:      c=%h, co=%b",
                         c, co);
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
        $dumpvars(0,a, b, clk, c, co);
    end

endmodule
