`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg ce;
    reg clk;
    wire [31:0] p;

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
            a <= 32'd0;
            b <= 32'd0;
            ce <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Multiplication (10 * 5)", test_num);
            a <= 32'd10;
            b <= 32'd5;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse Multiplication (0 * 500)", test_num);
            a <= 32'd0;
            b <= 32'd500;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sparse Multiplication (1234 * 0)", test_num);
            a <= 32'd1234;
            b <= 32'd0;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Multiplication (999 * 1)", test_num);
            a <= 32'd999;
            b <= 32'd1;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd999);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable (CE) Disabled Test", test_num);

            a <= 32'd2;
            b <= 32'd2;
            ce <= 1'b1;
            @(posedge clk);
            #1;

            a <= 32'd10;
            b <= 32'd10;
            ce <= 1'b0;
            repeat (2) @(posedge clk);
            #1;




            if (p == 32'd100) begin
                $display("FAIL: Output updated despite CE=0");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Output did not update to 100 while CE=0");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Large Value Multiplication (65536 * 65536)", test_num);
            a <= 32'h00010000;
            b <= 32'h00010000;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max Value and Sparse Property (0xFFFFFFFF * 0)", test_num);
            a <= 32'hFFFFFFFF;
            b <= 32'd0;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Pipelined/Sequential Flow Test", test_num);
            a <= 32'd7;
            b <= 32'd8;
            ce <= 1'b1;
            @(posedge clk);
            #1;
            a <= 32'd12;
            b <= 32'd12;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd144);
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
        input [31:0] expected_p;
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
