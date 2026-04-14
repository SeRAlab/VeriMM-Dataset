`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg [2:0] sel;
    wire w;
    wire x;
    wire y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .sel(sel),
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
            data = 4'b0000;
            sel = 3'b111;
            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Select Current Data (sel=0)", test_num);
            data = 4'b1011;
            sel = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Select Pipeline Stage 1 (sel=1)", test_num);
            data = 4'b1100;
            @(posedge clk);
            #1;
            data = 4'b0011;
            sel = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Select Pipeline Stage 2 (sel=2)", test_num);
            data = 4'b1010;
            @(posedge clk);
            #1;
            data = 4'b0101;
            @(posedge clk);
            #1;
            data = 4'b0000;
            sel = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Select Pipeline Stage 3 (sel=3)", test_num);
            data = 4'b0111;
            @(posedge clk);
            #1;
            data = 4'b0000;
            @(posedge clk);
            #1;
            data = 4'b0000;
            @(posedge clk);
            #1;
            sel = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Invalid Selection (sel=4)", test_num);
            data = 4'b1111;
            sel = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Invalid Selection (sel=7)", test_num);
            data = 4'b1111;
            sel = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_w;
        input expected_x;
        input expected_y;
        input expected_z;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%b, x=%b, y=%b, z=%b",
                         w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b, x=%b, y=%b, z=%b",
                         expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      w=%b, x=%b, y=%b, z=%b",
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
        $dumpvars(0,clk, data, sel, w, x, y, z);
    end

endmodule
