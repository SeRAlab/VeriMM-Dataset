`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg ena;
    reg load;
    reg [2:0] sel;
    wire [3:0] q;
    wire xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .ena(ena),
        .load(load),
        .sel(sel),
        .q(q),
        .xor_out(xor_out)
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
            sel = 0;
            data0 = 0; data1 = 0; data2 = 0; data3 = 0; data4 = 0; data5 = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            sel = 3'd0;
            data0 = 4'b0001;
            #1;

            $display("Testcase 001: Reset check");
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            sel = 3'd0;
            data0 = 4'hA;
            load = 1;
            @(posedge clk);
            #2;

            $display("Testcase 002: Load data0 (4'hA)");
            #1;

            check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            sel = 3'd5;
            data5 = 4'h7;
            load = 1;
            @(posedge clk);
            #2;

            $display("Testcase 003: Load data5 (4'h7)");
            #1;

            check_outputs(4'h7, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            sel = 3'd0;
            data0 = 4'h8;
            load = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            load = 0;
            ena = 1;
            @(posedge clk);
            #2;


            $display("Testcase 004: Shift Left Cyclic (8 -> 1)");
            #1;

            check_outputs(4'h1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            sel = 3'd1;
            data1 = 4'hC;
            load = 1;
            @(posedge clk);
            #2;
            @(negedge clk);
            load = 0;
            ena = 1;
            @(posedge clk);
            #2;


            $display("Testcase 005: Shift Left Cyclic (C -> 9)");
            #1;

            check_outputs(4'h9, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(negedge clk);
            sel = 3'd2;
            data2 = 4'hF;
            load = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            load = 0;
            sel = 3'd3;
            data3 = 4'hE;
            #2;

            $display("Testcase 006: XOR check with sel change");
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clk);
            sel = 3'd4;
            data4 = 4'h3;
            load = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            load = 0;
            data4 = 4'h2;
            #2;

            $display("Testcase 007: XOR check with data change");
            #1;

            check_outputs(4'h3, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            @(negedge clk);
            sel = 3'd0;
            data0 = 4'h5;
            load = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            load = 1;
            ena = 1;
            sel = 3'd1;
            data1 = 4'hB;
            @(posedge clk);
            #2;

            $display("Testcase 008: Priority check (Load vs Ena)");
            #1;

            check_outputs(4'hB, 1'b0);
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
        input [3:0] expected_q;
        input expected_xor_out;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: q=%h, xor_out=%b",
                         q, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, xor_out=%b",
                         expected_q, expected_xor_out);
                $display("  Got:      q=%h, xor_out=%b",
                         q, xor_out);
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
        $dumpvars(0,areset, clk, data0, data1, data2, data3, data4, data5, ena, load, sel, q, xor_out);
    end

endmodule
