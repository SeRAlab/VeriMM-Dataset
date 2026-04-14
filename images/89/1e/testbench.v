`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [3:0] b;
    reg clk;
    reg rst;
    wire [11:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset behavior", test_num);
            reset_dut();

            a = 8'hFF;
            b = 4'hF;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Concatenation (AA, 5)", test_num);
            reset_dut();
            a = 8'hAA;
            b = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h5AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            a = 8'h00;
            b = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            a = 8'hFF;
            b = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 1", test_num);
            reset_dut();
            a = 8'h12;
            b = 4'hE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hE12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern 2", test_num);
            reset_dut();
            a = 8'h0F;
            b = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h10F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB of B", test_num);
            reset_dut();
            a = 8'h00;
            b = 4'h8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB of A", test_num);
            reset_dut();
            a = 8'h01;
            b = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h001);
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
        input [11:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,a, b, clk, rst, c);
    end

endmodule
