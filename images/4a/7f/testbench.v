`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg rst_n;
    reg [2:0] sel;
    wire [11:0] final_out;
    wire [3:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .rst_n(rst_n),
        .sel(sel),
        .final_out(final_out),
        .mux_out(mux_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            sel = 0;
            data0 = 4'hA; data1 = 4'hB; data2 = 4'hC;
            data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            $display("\nReset Complete.");
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial Selection and First Step...");
            reset_dut();
            sel = 3'b000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'h001, 4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Selection Change and Counter Mid-seq...");
            reset_dut();
            sel = 3'b011;
            repeat(4) @(posedge clk);
            #2;

            #1;


            check_outputs(12'h00F, 4'hD);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: final_out Concatenation (sel=111)...");
            reset_dut();

            sel = 3'b101;
            @(posedge clk);

            sel = 3'b111;
            @(posedge clk);
            #2;



            #1;




            check_outputs(12'hF03, 4'hF);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Counter Full Cycle Wrap-around...");
            reset_dut();
            sel = 3'b010;
            repeat(12) @(posedge clk);
            #2;

            #1;


            check_outputs(12'h000, 4'hC);
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
        input [3:0] expected_mux_out;
        begin
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, mux_out=%h",
                         final_out, mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, mux_out=%h",
                         expected_final_out, expected_mux_out);
                $display("  Got:      final_out=%h, mux_out=%h",
                         final_out, mux_out);
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
        $dumpvars(0,clk, data0, data1, data2, data3, data4, data5, rst_n, sel, final_out, mux_out);
    end

endmodule
