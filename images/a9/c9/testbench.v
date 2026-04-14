`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [5:0] b;
    reg ce;
    reg clk;
    wire [12:0] p;

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
            a <= 8'h0;
            b <= 6'h0;
            ce <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic multiplication (10 * 5), ce=1", test_num);
            a <= 8'd10;
            b <= 6'd5;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by zero (255 * 0), ce=1", test_num);
            a <= 8'd255;
            b <= 6'd0;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Clock Enable check. Load 100, then change inputs with ce=0", test_num);


            a <= 8'd10;
            b <= 6'd10;
            ce <= 1'b1;
            @(posedge clk);
            #2;


            a <= 8'd20;
            b <= 6'd20;
            ce <= 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'd100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (255 * 63) with 13-bit truncation", test_num);
            a <= 8'd255;
            b <= 6'd63;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'h1E01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 (128 * 32)", test_num);
            a <= 8'd128;
            b <= 6'd32;
            ce <= 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'd4096);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Small values (7 * 9)", test_num);
            a <= 8'd7;
            b <= 6'd9;
            ce <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'd63);
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
        input [12:0] expected_p;
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
