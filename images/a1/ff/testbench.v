`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [2:0] select;
    wire [7:0] out;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .select(select),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 8'h00;
            select = 3'b000;
            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            reset_dut();
            d = 8'h00;
            select = 3'b000;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            reset_dut();
            d = 8'hFF;
            select = 3'b111;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd8, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits AA", test_num);
            reset_dut();
            d = 8'hAA;
            select = 3'b010;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd4, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits 55", test_num);
            reset_dut();
            d = 8'h55;
            select = 3'b101;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd4, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set", test_num);
            reset_dut();
            d = 8'h80;
            select = 3'b111;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd1, 8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 37", test_num);
            reset_dut();
            d = 8'h37;
            select = 3'b000;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd5, 8'h37);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Seven bits set", test_num);
            reset_dut();
            d = 8'hFE;
            select = 3'b001;
            @(negedge clk);
            #2;
            #1;

            check_outputs(8'd7, 8'hFE);
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
        input [7:0] expected_out;
        input [7:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%h, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%h, q=%h",
                         out, q);
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
        $dumpvars(0,clk, d, select, out, q);
    end

endmodule
