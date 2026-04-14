`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg clk;
    wire [7:0] w;
    wire [7:0] x;
    wire [7:0] y;
    wire [7:0] z;

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
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 8'h00; b = 8'h00; c = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 8'd10; b = 8'd20; c = 8'd30;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd20, 8'd30, 8'd20, 8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 8'd100; b = 8'd50; c = 8'd25;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd100, 8'd100, 8'd100, 8'd100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 8'd40; b = 8'd80; c = 8'd40;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd80, 8'd80, 8'd80, 8'd80);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 8'hFF; b = 8'hFF; c = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 8'd5; b = 8'd10; c = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd10, 8'd255, 8'd10, 8'd255);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 8'hA5; b = 8'h5A; c = 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5, 8'hA5, 8'hA5, 8'hA5);
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
        input [7:0] expected_w;
        input [7:0] expected_x;
        input [7:0] expected_y;
        input [7:0] expected_z;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%h, x=%h, y=%h, z=%h",
                         w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h, x=%h, y=%h, z=%h",
                         expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      w=%h, x=%h, y=%h, z=%h",
                         w, x, y, z);
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
        $dumpvars(0,a, b, c, clk, w, x, y, z);
    end

endmodule
