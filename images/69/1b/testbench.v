`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] bitmask_x;
    reg [8:0] bitmask_y;
    reg [10:0] clamp_mask_x;
    reg [10:0] clamp_mask_y;
    reg clamp_x;
    reg clamp_y;
    reg de_clk;
    reg [10:0] x;
    reg [10:0] y;
    wire clamp;
    wire [8:0] new_x;
    wire [8:0] new_x_d;
    wire [8:0] new_y;
    wire [8:0] new_y_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bitmask_x(bitmask_x),
        .bitmask_y(bitmask_y),
        .clamp_mask_x(clamp_mask_x),
        .clamp_mask_y(clamp_mask_y),
        .clamp_x(clamp_x),
        .clamp_y(clamp_y),
        .de_clk(de_clk),
        .x(x),
        .y(y),
        .clamp(clamp),
        .new_x(new_x),
        .new_x_d(new_x_d),
        .new_y(new_y),
        .new_y_d(new_y_d)
    );

    // Clock generation (10ns period)
    initial begin
        de_clk = 0;
        forever #5 de_clk = ~de_clk;
    end

        task reset_dut;

        begin
            clamp_x = 0;
            clamp_y = 0;
            x = 0;
            y = 0;
            clamp_mask_x = 11'h7FF;
            clamp_mask_y = 11'h7FF;
            bitmask_x = 0;
            bitmask_y = 0;
            repeat(2) @(posedge de_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            x = 11'h1AA;
            y = 11'h055;
            clamp_x = 0;
            clamp_y = 0;

            repeat(3) @(posedge de_clk);
            #1;

            #1;


            check_outputs(1'b0, 9'h1AA, 9'h1AA, 9'h055, 9'h055);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            x = 11'h500;
            clamp_mask_x = 11'h400;
            clamp_x = 1;
            bitmask_x = 9'h0FF;
            y = 11'h123;
            clamp_y = 0;

            repeat(3) @(posedge de_clk);
            #1;

            #1;


            check_outputs(1'b1, 9'h0FF, 9'h0FF, 9'h123, 9'h123);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            x = 11'h100;
            clamp_x = 0;
            y = 11'h600;
            clamp_mask_y = 11'h500;
            clamp_y = 1;
            bitmask_y = 9'h1AA;

            repeat(3) @(posedge de_clk);
            #1;

            #1;


            check_outputs(1'b1, 9'h100, 9'h100, 9'h1AA, 9'h1AA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            x = 11'h100;
            clamp_mask_x = 11'h200;
            clamp_x = 1;
            y = 11'h050;
            clamp_mask_y = 11'h100;
            clamp_y = 1;

            repeat(3) @(posedge de_clk);
            #1;

            #1;


            check_outputs(1'b0, 9'h100, 9'h100, 9'h050, 9'h050);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            x = 11'h7FF;
            y = 11'h7FF;
            clamp_mask_x = 11'h100;
            clamp_mask_y = 11'h100;
            clamp_x = 1;
            clamp_y = 1;
            bitmask_x = 9'h155;
            bitmask_y = 9'h0AA;

            repeat(3) @(posedge de_clk);
            #1;
            #1;

            check_outputs(1'b1, 9'h155, 9'h155, 9'h0AA, 9'h0AA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            x = 11'h6AA;
            y = 11'h755;
            clamp_x = 0;
            clamp_y = 0;

            repeat(3) @(posedge de_clk);
            #1;

            #1;


            check_outputs(1'b0, 9'h0AA, 9'h0AA, 9'h155, 9'h155);
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
        input expected_clamp;
        input [8:0] expected_new_x;
        input [8:0] expected_new_x_d;
        input [8:0] expected_new_y;
        input [8:0] expected_new_y_d;
        begin
            if (expected_clamp === (expected_clamp ^ clamp ^ expected_clamp) &&
                expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_x_d === (expected_new_x_d ^ new_x_d ^ expected_new_x_d) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y) &&
                expected_new_y_d === (expected_new_y_d ^ new_y_d ^ expected_new_y_d)) begin
                $display("PASS");
                $display("  Outputs: clamp=%b, new_x=%h, new_x_d=%h, new_y=%h, new_y_d=%h",
                         clamp, new_x, new_x_d, new_y, new_y_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clamp=%b, new_x=%h, new_x_d=%h, new_y=%h, new_y_d=%h",
                         expected_clamp, expected_new_x, expected_new_x_d, expected_new_y, expected_new_y_d);
                $display("  Got:      clamp=%b, new_x=%h, new_x_d=%h, new_y=%h, new_y_d=%h",
                         clamp, new_x, new_x_d, new_y, new_y_d);
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
        $dumpvars(0,bitmask_x, bitmask_y, clamp_mask_x, clamp_mask_y, clamp_x, clamp_y, de_clk, x, y, clamp, new_x, new_x_d, new_y, new_y_d);
    end

endmodule
