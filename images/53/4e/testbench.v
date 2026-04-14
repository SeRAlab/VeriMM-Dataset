`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ct;
    reg itr;
    reg [31:0] x0;
    reg [31:0] x1;
    wire [31:0] y0;
    wire [31:0] y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ct(ct),
        .itr(itr),
        .x0(x0),
        .x1(x1),
        .y0(y0),
        .y1(y1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            itr <= 0;
            ct <= 5'b0;
            x0 <= 32'b0;
            x1 <= 32'b0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Idle Zero State", test_num);
            reset_dut();
            itr <= 0;
            ct <= 5'd0;
            x0 <= 32'h0;
            x1 <= 32'h0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Transformation (ct=1)", test_num);
            reset_dut();
            itr <= 1;
            ct <= 5'd1;
            x0 <= 32'hAAAA_AAAA;
            x1 <= 32'h5555_5555;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(y0, y1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Counter (ct=31)", test_num);
            reset_dut();
            itr <= 1;
            ct <= 5'd31;
            x0 <= 32'h1234_5678;
            x1 <= 32'h8765_4321;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(y0, y1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Interrupted Iteration", test_num);
            reset_dut();
            itr <= 1;
            ct <= 5'd10;
            x0 <= 32'hFFFF_FFFF;
            x1 <= 32'h0000_0000;
            @(posedge clk);
            itr <= 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(y0, y1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Data Values", test_num);
            reset_dut();
            itr <= 1;
            ct <= 5'd15;
            x0 <= 32'hFFFF_FFFF;
            x1 <= 32'hFFFF_FFFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(y0, y1);
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
        input [31:0] expected_y0;
        input [31:0] expected_y1;
        begin
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h",
                         y0, y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h",
                         expected_y0, expected_y1);
                $display("  Got:      y0=%h, y1=%h",
                         y0, y1);
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
        $dumpvars(0,clk, ct, itr, x0, x1, y0, y1);
    end

endmodule
