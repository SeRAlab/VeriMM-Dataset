`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] LR_in;
    reg LR_load_en;
    reg clk;
    wire [7:0] LR_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LR_in(LR_in),
        .LR_load_en(LR_load_en),
        .clk(clk),
        .LR_out(LR_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            LR_in = 8'h00;
            LR_load_en = 1;
            @(posedge clk);
            #1;
            LR_load_en = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Load 0xA5", test_num);
            reset_dut();

            LR_in = 8'hA5;
            LR_load_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Hold (load_en=0)", test_num);
            reset_dut();


            LR_in = 8'h3C;
            LR_load_en = 1;
            @(posedge clk);
            #1;


            LR_in = 8'hFF;
            LR_load_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load All Ones", test_num);
            reset_dut();

            LR_in = 8'hFF;
            LR_load_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load All Zeros", test_num);
            reset_dut();


            LR_in = 8'hAA;
            LR_load_en = 1;
            @(posedge clk);
            #1;


            LR_in = 8'h00;
            LR_load_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successive Loads", test_num);
            reset_dut();

            LR_load_en = 1;
            LR_in = 8'h11;
            @(posedge clk);
            #1;
            LR_in = 8'h22;
            @(posedge clk);
            #1;
            LR_in = 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_LR_out;
        begin
            if (expected_LR_out === (expected_LR_out ^ LR_out ^ expected_LR_out)) begin
                $display("PASS");
                $display("  Outputs: LR_out=%h",
                         LR_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LR_out=%h",
                         expected_LR_out);
                $display("  Got:      LR_out=%h",
                         LR_out);
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
        $dumpvars(0,LR_in, LR_load_en, clk, LR_out);
    end

endmodule
