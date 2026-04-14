`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] I;
    reg [7:0] Q;
    reg clk;
    reg [7:0] in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .Q(Q),
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in <= 8'd0;
            I <= 8'd0;
            Q <= 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            reset_dut();
            in = 8'd0;
            I = 8'd0;
            Q = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        reg [15:0] stage1;
        reg [15:0] stage2;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unity I component, Zero Q", test_num);
            reset_dut();
            in = 8'd100;
            I = 8'd255;
            Q = 8'd0;
            @(posedge clk);
            #1;

            stage1 = (in * I + in * Q) >> 8;
            stage2 = (stage1 * I + stage1 * Q) >> 8;
            #1;

            check_outputs(stage2[7:0]);
        end
        endtask

    task testcase003;

        reg [15:0] stage1;
        reg [15:0] stage2;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unity Q component, Zero I", test_num);
            reset_dut();
            in = 8'd150;
            I = 8'd0;
            Q = 8'd255;
            @(posedge clk);
            #1;
            stage1 = (in * I + in * Q) >> 8;
            stage2 = (stage1 * I + stage1 * Q) >> 8;
            #1;

            check_outputs(stage2[7:0]);
        end
        endtask

    task testcase004;

        reg [15:0] stage1;
        reg [15:0] stage2;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Balanced I and Q (45 degrees)", test_num);
            reset_dut();
            in = 8'd200;
            I = 8'd128;
            Q = 8'd128;
            @(posedge clk);
            #1;
            stage1 = (in * I + in * Q) >> 8;
            stage2 = (stage1 * I + stage1 * Q) >> 8;
            #1;

            check_outputs(stage2[7:0]);
        end
        endtask

    task testcase005;

        reg [15:0] stage1;
        reg [15:0] stage2;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum scale inputs", test_num);
            reset_dut();
            in = 8'd255;
            I = 8'd255;
            Q = 8'd255;
            @(posedge clk);
            #1;
            stage1 = (in * I + in * Q) >> 8;
            stage2 = (stage1 * I + stage1 * Q) >> 8;
            #1;

            check_outputs(stage2[7:0]);
        end
        endtask

    task testcase006;

        reg [15:0] stage1;
        reg [15:0] stage2;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small signals", test_num);
            reset_dut();
            in = 8'd16;
            I = 8'd32;
            Q = 8'd32;
            @(posedge clk);
            #1;
            stage1 = (in * I + in * Q) >> 8;
            stage2 = (stage1 * I + stage1 * Q) >> 8;
            #1;

            check_outputs(stage2[7:0]);
        end
        endtask

    task testcase007;

        reg [15:0] stage1;
        reg [15:0] stage2;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary mixed components", test_num);
            reset_dut();
            in = 8'd127;
            I = 8'd200;
            Q = 8'd50;
            @(posedge clk);
            #1;
            stage1 = (in * I + in * Q) >> 8;
            stage2 = (stage1 * I + stage1 * Q) >> 8;
            #1;

            check_outputs(stage2[7:0]);
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
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,I, Q, clk, in, out);
    end

endmodule
