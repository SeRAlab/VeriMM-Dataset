`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] in;
    reg ld_a;
    reg ld_b;
    reg ld_o;
    reg rst;
    wire [23:0] hpo;
    wire [23:0] lpo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .ld_a(ld_a),
        .ld_b(ld_b),
        .ld_o(ld_o),
        .rst(rst),
        .hpo(hpo),
        .lpo(lpo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;
            ld_a = 0;
            ld_b = 0;
            ld_o = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            in = 24'd100; ld_a = 1; @(posedge clk); #1; ld_a = 0;

            in = 24'd40;  ld_b = 1; @(posedge clk); #1; ld_b = 0;

            ld_o = 1; @(posedge clk); #1; ld_o = 0;

            #1;


            check_outputs(24'd30, 24'd70);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            in = -24'sd100; ld_a = 1; @(posedge clk); #1; ld_a = 0;

            in = -24'sd40;  ld_b = 1; @(posedge clk); #1; ld_b = 0;

            ld_o = 1; @(posedge clk); #1; ld_o = 0;

            #1;


            check_outputs(-24'sd30, -24'sd70);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in = 24'sd500; ld_a = 1; @(posedge clk); #1; ld_a = 0;
            in = -24'sd100; ld_b = 1; @(posedge clk); #1; ld_b = 0;
            ld_o = 1; @(posedge clk); #1; ld_o = 0;

            #1;


            check_outputs(24'sd300, 24'sd200);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in = 24'h7FFFFF; ld_a = 1; @(posedge clk); #1; ld_a = 0;
            in = 24'h7FFFFF; ld_b = 1; @(posedge clk); #1; ld_b = 0;
            ld_o = 1; @(posedge clk); #1; ld_o = 0;

            #1;


            check_outputs(24'h0, 24'h7FFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            in = 24'd10; ld_a = 1; @(posedge clk); #1; ld_a = 0;
            in = 24'd20; ld_b = 1; @(posedge clk); #1; ld_b = 0;
            ld_o = 1; @(posedge clk); #1; ld_o = 0;


            in = 24'd100; ld_a = 1; @(posedge clk); #1; ld_a = 0;
            in = 24'd200; ld_b = 1; @(posedge clk); #1; ld_b = 0;



            #1;




            check_outputs(-24'sd5, 24'sd15);
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
        input [23:0] expected_hpo;
        input [23:0] expected_lpo;
        begin
            if (expected_hpo === (expected_hpo ^ hpo ^ expected_hpo) &&
                expected_lpo === (expected_lpo ^ lpo ^ expected_lpo)) begin
                $display("PASS");
                $display("  Outputs: hpo=%h, lpo=%h",
                         hpo, lpo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hpo=%h, lpo=%h",
                         expected_hpo, expected_lpo);
                $display("  Got:      hpo=%h, lpo=%h",
                         hpo, lpo);
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
        $dumpvars(0,clk, in, ld_a, ld_b, ld_o, rst, hpo, lpo);
    end

endmodule
