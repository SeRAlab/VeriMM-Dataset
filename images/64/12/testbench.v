`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [2:0] select;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .select(select),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 8'h00;
            select = 0;
            repeat(8) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select 0 immediate entry", test_num);
            d = 8'hA5;
            @(posedge clk);
            #1;
            select = 3'd0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select 7 full pipe shift", test_num);
            d = 8'h5A;
            @(posedge clk);
            d = 8'h00;
            repeat(7) @(posedge clk);
            #1;
            select = 3'd7;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select 3 middle pipe check", test_num);


            d = 8'h11; @(posedge clk);
            d = 8'h22; @(posedge clk);
            d = 8'h33; @(posedge clk);
            d = 8'h44; @(posedge clk);
            #1;
            select = 3'd3;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Full register fill, select index 5", test_num);

            d = 8'h10; @(posedge clk);
            d = 8'h20; @(posedge clk);
            d = 8'h30; @(posedge clk);
            d = 8'h40; @(posedge clk);
            d = 8'h50; @(posedge clk);
            d = 8'h60; @(posedge clk);
            d = 8'h70; @(posedge clk);
            d = 8'h80; @(posedge clk);
            #1;
            select = 3'd5;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence after shifts", test_num);
            d = 8'hFF; @(posedge clk);
            d = 8'h00;
            repeat(4) @(posedge clk);
            #1;
            select = 3'd4;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, select, q);
    end

endmodule
