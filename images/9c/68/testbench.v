`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire out;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
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
            @(posedge clk);
            load = 1;
            data = 100'd0;
            ena = 2'b00;
            a = 0;
            b = 0;
            @(posedge clk);
            load = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            @(posedge clk);
            load = 1;
            data = 100'hF0F0F0F0F0F0F0F0F0F0F0F0F;
            @(posedge clk);
            load = 0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 100'hF0F0F0F0F0F0F0F0F0F0F0F0F);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge clk);
            load = 1;
            data = 100'h1;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 100'h2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(posedge clk);
            load = 1;
            data = 100'h1;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, (100'b1 << 99));
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge clk);
            a = 1;
            b = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 100'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(posedge clk);
            load = 1;
            data = (100'b1 << 99);
            a = 1;
            b = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 100'h1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            @(posedge clk);
            load = 1;
            data = 100'hA;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 100'h28);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            @(posedge clk);
            load = 1;
            data = 100'h55;
            ena = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 100'h55);
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
        input expected_out;
        input [99:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%h",
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
        $dumpvars(0,a, b, clk, data, ena, load, out, q);
    end

endmodule
