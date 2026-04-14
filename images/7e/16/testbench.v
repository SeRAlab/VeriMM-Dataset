`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg [2:0] c;
    reg clk;
    reg [2:0] d;
    reg [1:0] e;
    reg rst;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .e(e),
        .rst(rst),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0; b = 0; c = 0; d = 0; e = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 3'b101; b = 3'b101;
            c = 3'b010; d = 3'b010;
            e = 2'b11;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 3'b111; b = 3'b000;
            c = 3'b010; d = 3'b010;
            e = 2'b11;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = 3'b101; b = 3'b101;
            c = 3'b110; d = 3'b011;
            e = 2'b11;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 3'b101; b = 3'b101;
            c = 3'b010; d = 3'b010;
            e = 2'b00;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 3'b111; b = 3'b111;
            c = 3'b111; d = 3'b111;
            e = 2'b11;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = 3'b000; b = 3'b000;
            c = 3'b000; d = 3'b000;
            e = 2'b11;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin

            rst = 1;
            a = 3'b101; b = 3'b101;
            c = 3'b010; d = 3'b010;
            e = 2'b11;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
            rst = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,a, b, c, clk, d, e, rst, y);
    end

endmodule
