`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg d;
    reg reset;
    wire Cout;
    wire [31:0] D;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .d(d),
        .reset(reset),
        .Cout(Cout),
        .D(D),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 32'h0;
            B = 32'h0;
            d = 1'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic addition (10+20), d=0", test_num);
            reset_dut();
            A = 32'd10;
            B = 32'd20;
            d = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic addition (50+50), d=1", test_num);
            reset_dut();
            A = 32'd50;
            B = 32'd50;
            d = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'd99, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry out condition (Max+1), d=0", test_num);
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            d = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry out condition (Max+1), d=1", test_num);
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            d = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large values addition, d=1", test_num);
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            d = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFD, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sum=0, d=1", test_num);
            reset_dut();
            A = 32'h0;
            B = 32'h0;
            d = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random values, d=0", test_num);
            reset_dut();
            A = 32'h12345678;
            B = 32'h11111111;
            d = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 32'h23456789, 1'b0);
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
        input expected_Cout;
        input [31:0] expected_D;
        input expected_q;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_D === (expected_D ^ D ^ expected_D) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, D=%h, q=%b",
                         Cout, D, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, D=%h, q=%b",
                         expected_Cout, expected_D, expected_q);
                $display("  Got:      Cout=%b, D=%h, q=%b",
                         Cout, D, q);
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
        $dumpvars(0,A, B, clk, d, reset, Cout, D, q);
    end

endmodule
