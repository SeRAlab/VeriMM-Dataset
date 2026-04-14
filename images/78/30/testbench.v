`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [3:0] data;
    reg ena;
    reg [15:0] in;
    reg load;
    wire [11:0] final_out;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data(data),
        .ena(ena),
        .in(in),
        .load(load),
        .final_out(final_out),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            load = 0;
            ena = 0;
            data = 0;
            in = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(12'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Check", test_num);
            reset_dut();
            data = 4'hF;
            in = 16'hFF_FF;
            load = 1;
            @(posedge clk);
            #2 load = 0;

            #1;


            check_outputs(12'd525, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single Shift Check", test_num);
            reset_dut();
            data = 4'b1010;
            in = 16'b01100100_01100100;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            ena = 1;
            @(posedge clk);
            #2 ena = 0;




            #1;





            check_outputs(12'd105, 8'd50, 8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multi-Shift Check", test_num);
            reset_dut();
            data = 4'b1000;
            in = 16'h8080;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            ena = 1;
            repeat(2) @(posedge clk);
            #2 ena = 0;




            #1;





            check_outputs(12'd66, 8'd32, 8'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable Gating Check", test_num);
            reset_dut();
            data = 4'hC;
            in = 16'h0A0A;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            ena = 0;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(12'd32, 8'h0A, 8'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Async Reset Mid-Cycle Check", test_num);
            reset_dut();
            data = 4'hF;
            in = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            #2 areset = 1;
            #1;

            #1;


            check_outputs(12'd0, 8'd0, 8'd0);
            #5 areset = 0;
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
        input [11:0] expected_final_out;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, out_hi=%h, out_lo=%h",
                         final_out, out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, out_hi=%h, out_lo=%h",
                         expected_final_out, expected_out_hi, expected_out_lo);
                $display("  Got:      final_out=%h, out_hi=%h, out_lo=%h",
                         final_out, out_hi, out_lo);
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
        $dumpvars(0,areset, clk, data, ena, in, load, final_out, out_hi, out_lo);
    end

endmodule
