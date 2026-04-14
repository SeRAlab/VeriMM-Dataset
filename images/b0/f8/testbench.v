`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ld_en;
    reg pc_inc;
    reg [15:0] pc_load;
    reg reset;
    wire [15:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ld_en(ld_en),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .reset(reset),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ld_en = 0;
            pc_inc = 0;
            pc_load = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load external value", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            ld_en = 1;
            pc_load = 16'hABCD;
            @(posedge clk);
            #1;
            ld_en = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Increment", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            pc_inc = 1;
            repeat(5) @(posedge clk);
            #1;
            pc_inc = 0;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            ld_en = 1;
            pc_inc = 1;
            pc_load = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Current Value", test_num);
            reset_dut();

            @(posedge clk);
            #1 ld_en = 1; pc_load = 16'h5555;
            @(posedge clk);
            #1 ld_en = 0; pc_inc = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PC Rollover", test_num);
            reset_dut();

            @(posedge clk);
            #1 ld_en = 1; pc_load = 16'hFFFF;
            @(posedge clk);
            #1 ld_en = 0; pc_inc = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment then Load", test_num);
            reset_dut();
            pc_inc = 1;
            repeat(10) @(posedge clk);
            #1 pc_inc = 0; ld_en = 1; pc_load = 16'h7777;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7777);
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
        input [15:0] expected_pc_out;
        begin
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h",
                         pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h",
                         expected_pc_out);
                $display("  Got:      pc_out=%h",
                         pc_out);
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
        $dumpvars(0,clk, ld_en, pc_inc, pc_load, reset, pc_out);
    end

endmodule
