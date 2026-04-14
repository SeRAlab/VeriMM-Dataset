`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [7:0] b;
    reg ce;
    reg clk;
    wire [23:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce <= 0;
            a <= 0;
            b <= 0;
            @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Multiplication (10 * 5)", test_num);
            a <= 16'd10;
            b <= 8'd5;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero (255 * 0)", test_num);
            a <= 16'd255;
            b <= 8'd0;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (65535 * 255)", test_num);
            a <= 16'hFFFF;
            b <= 8'hFF;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFEFF01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Powers of Two (256 * 64)", test_num);
            a <= 16'd256;
            b <= 8'd64;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'd16384);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable (CE) Check", test_num);

            a <= 16'd12;
            b <= 8'd12;
            ce <= 1'b1;
            @(posedge clk);
            #1;

            a <= 16'd50;
            b <= 8'd2;
            ce <= 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(24'd144);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Large Values (12345 * 123)", test_num);
            a <= 16'd12345;
            b <= 8'd123;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'd1518435);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (4096 * 1)", test_num);
            a <= 16'd4096;
            b <= 8'd1;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'd4096);
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
        input [23:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
