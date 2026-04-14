`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_en;
    reg clk_i;
    reg [31:0] prbs_seed_i;
    reg prbs_seed_init;
    reg rst_i;
    wire [31:0] prbs_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_en(clk_en),
        .clk_i(clk_i),
        .prbs_seed_i(prbs_seed_i),
        .prbs_seed_init(prbs_seed_init),
        .rst_i(rst_i),
        .prbs_o(prbs_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            clk_en = 0;
            prbs_seed_init = 0;
            prbs_seed_i = 32'h0;
            @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verifying Reset Seed Loading...", test_num);
            reset_dut();

            prbs_seed_i = 32'h12345678;
            rst_i = 1;
            @(posedge clk_i);
            #1 rst_i = 0;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Verifying Seed Initialization Signal...", test_num);
            reset_dut();

            prbs_seed_i = 32'hA5A5A5A5;
            prbs_seed_init = 1;
            @(posedge clk_i);
            #1 prbs_seed_init = 0;

            #1;


            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Verifying Clock Enable Inhibition (Hold State)...", test_num);
            reset_dut();


            prbs_seed_i = 32'h55AAFF00;
            prbs_seed_init = 1;
            @(posedge clk_i);
            #1 prbs_seed_init = 0;


            clk_en = 0;
            repeat(10) @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h55AAFF00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Verifying All-Zeros Seed Initialization...", test_num);
            reset_dut();

            prbs_seed_i = 32'h00000000;
            prbs_seed_init = 1;
            @(posedge clk_i);
            #1 prbs_seed_init = 0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verifying Seed Overwrite during Run...", test_num);
            reset_dut();


            prbs_seed_i = 32'h1;
            rst_i = 1;
            @(posedge clk_i);
            #1 rst_i = 0;
            clk_en = 1;
            repeat(5) @(posedge clk_i);


            prbs_seed_i = 32'hFEEDFACE;
            prbs_seed_init = 1;
            @(posedge clk_i);
            #1 prbs_seed_init = 0;
            clk_en = 0;

            #1;


            check_outputs(32'hFEEDFACE);
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
        input [31:0] expected_prbs_o;
        begin
            if (expected_prbs_o === (expected_prbs_o ^ prbs_o ^ expected_prbs_o)) begin
                $display("PASS");
                $display("  Outputs: prbs_o=%h",
                         prbs_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prbs_o=%h",
                         expected_prbs_o);
                $display("  Got:      prbs_o=%h",
                         prbs_o);
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
        $dumpvars(0,clk_en, clk_i, prbs_seed_i, prbs_seed_init, rst_i, prbs_o);
    end

endmodule
