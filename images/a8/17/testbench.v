`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] entrada;
    reg load;
    wire [15:0] saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .entrada(entrada),
        .load(load),
        .saida(saida)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            entrada = 16'h0000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case %0d: Basic Load 0xABCD", test_num);
            reset_dut();
            entrada = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case %0d: Hold Value (Load=0)", test_num);
            reset_dut();

            entrada = 16'h1234;
            load = 1;
            @(posedge clk);
            #1;

            entrada = 16'h5678;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case %0d: All Bits High", test_num);
            reset_dut();
            entrada = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case %0d: Load Zeros", test_num);
            reset_dut();

            entrada = 16'h55AA;
            load = 1;
            @(posedge clk);
            #1;

            entrada = 16'h0000;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Test Case %0d: Successive Loads", test_num);
            reset_dut();
            entrada = 16'hAAAA;
            load = 1;
            @(posedge clk);
            #1;
            entrada = 16'h5555;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
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
        input [15:0] expected_saida;
        begin
            if (expected_saida === (expected_saida ^ saida ^ expected_saida)) begin
                $display("PASS");
                $display("  Outputs: saida=%h",
                         saida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida=%h",
                         expected_saida);
                $display("  Got:      saida=%h",
                         saida);
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
        $dumpvars(0,clk, entrada, load, saida);
    end

endmodule
