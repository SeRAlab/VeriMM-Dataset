`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg add;
    reg [7:0] b;
    reg clk;
    reg div;
    reg mul;
    reg reset;
    reg sub;
    wire [15:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .add(add),
        .b(b),
        .clk(clk),
        .div(div),
        .mul(mul),
        .reset(reset),
        .sub(sub),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            a = 0;
            b = 0;
            add = 0;
            sub = 0;
            mul = 0;
            div = 0;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'd100;
            b = 8'd50;
            add = 1;
            @(posedge clk);
            #1;
            add = 0;
            $display("Testcase %0d: Addition 100 + 50", test_num);
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 8'd200;
            b = 8'd75;
            sub = 1;
            @(posedge clk);
            #1;
            sub = 0;
            $display("Testcase %0d: Subtraction 200 - 75", test_num);
            #1;

            check_outputs(16'd125);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'd12;
            b = 8'd12;
            mul = 1;
            @(posedge clk);
            #1;
            mul = 0;
            $display("Testcase %0d: Multiplication 12 * 12", test_num);
            #1;

            check_outputs(16'd144);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'd144;
            b = 8'd12;
            div = 1;
            @(posedge clk);
            #1;
            div = 0;
            $display("Testcase %0d: Division 144 / 12", test_num);
            #1;

            check_outputs(16'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            add = 1;
            @(posedge clk);
            #1;
            add = 0;
            $display("Testcase %0d: Max Addition 255 + 255", test_num);
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            mul = 1;
            @(posedge clk);
            #1;
            mul = 0;
            $display("Testcase %0d: Max Multiplication 255 * 255", test_num);
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 8'd50;
            b = 8'd50;
            sub = 1;
            @(posedge clk);
            #1;
            sub = 0;
            $display("Testcase %0d: Subtraction 50 - 50", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 8'd5;
            b = 8'd10;
            div = 1;
            @(posedge clk);
            #1;
            div = 0;
            $display("Testcase %0d: Division 5 / 10", test_num);
            #1;

            check_outputs(16'd0);
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
        input [15:0] expected_c;
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
        $dumpvars(0,a, add, b, clk, div, mul, reset, sub, c);
    end

endmodule
