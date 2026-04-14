`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [17:0] data_in;
    reg reset;
    reg sam_clk_en;
    reg sym_clk_en;
    wire [17:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .sam_clk_en(sam_clk_en),
        .sym_clk_en(sym_clk_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sam_clk_en = 0;
            sym_clk_en = 0;
            data_in = 18'd0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic output check at counter 0...");
            reset_dut();
            data_in = 18'sh12345;
            sam_clk_en = 1;
            sym_clk_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'sh12345);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Zero output check at counter 1...");
            reset_dut();
            data_in = 18'sh12345;
            sam_clk_en = 1;
            sym_clk_en = 1;
            @(posedge clk);
            data_in = 18'sh05555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'sh00000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Zero output check at counter 3...");
            reset_dut();
            data_in = 18'sh12345;
            sam_clk_en = 1;
            sym_clk_en = 1;
            repeat(3) @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(18'sh00000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Wraparound check (Phase 4 -> Phase 0)...");
            reset_dut();
            sam_clk_en = 1;
            sym_clk_en = 1;


            data_in = 18'sh0AAAA;
            @(posedge clk);


            repeat(3) @(posedge clk);


            data_in = 18'sh1BBBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(18'sh1BBBB);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Negative signed input check...");
            reset_dut();
            data_in = -18'sh00005;
            sam_clk_en = 1;
            sym_clk_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-18'sh00005);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: sam_clk_en gating check...");
            reset_dut();
            data_in = 18'sh10000;
            sam_clk_en = 1;
            @(posedge clk);

            sam_clk_en = 0;
            data_in = 18'sh20000;
            repeat(2) @(posedge clk);

            sam_clk_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(18'sh00000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Max positive signed value check...");
            reset_dut();
            data_in = 18'h1FFFF;



            data_in = 18'sh1FFFF;
            sam_clk_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(18'sh1FFFF);
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
        input [17:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, sam_clk_en, sym_clk_en, data_out);
    end

endmodule
