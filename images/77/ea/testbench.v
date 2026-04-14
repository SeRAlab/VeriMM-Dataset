`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] a;
    reg [2:0] b;
    reg clk;
    reg en;
    reg rst;
    wire [8:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .en(en),
        .rst(rst),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Multiplication (10 * 5)", test_num);
            reset_dut();
            a = 6'd10;
            b = 3'd5;
            en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication by Zero", test_num);
            reset_dut();
            a = 6'd45;
            b = 3'd0;
            en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (63 * 7)", test_num);
            reset_dut();
            a = 6'b111111;
            b = 3'b111;
            en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd441);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Signal Check", test_num);
            reset_dut();


            a = 6'd4;
            b = 3'd2;
            en = 1;
            @(posedge clk);
            #1;


            en = 0;
            a = 6'd20;
            b = 3'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence Multiplication", test_num);
            reset_dut();

            a = 6'd7; b = 3'd3; en = 1;
            @(posedge clk); #1;

            a = 6'd12; b = 3'd4; en = 1;
            @(posedge clk); #1;

            a = 6'd2; b = 3'd7; en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority Check", test_num);
            reset_dut();

            a = 6'd10; b = 3'd5; en = 1;
            @(posedge clk); #1;

            rst = 1;
            a = 6'd10; b = 3'd5; en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd0);
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
        input [8:0] expected_p;
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
        $dumpvars(0,a, b, clk, en, rst, p);
    end

endmodule
