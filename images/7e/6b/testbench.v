`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D1;
    reg [7:0] D2;
    reg clk;
    reg load;
    reg rst;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D1(D1),
        .D2(D2),
        .clk(clk),
        .load(load),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            D1 = 0;
            D2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();
            D1 = 8'd10;
            D2 = 8'd20;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            D1 = 8'd0;
            D2 = 8'd0;
            @(posedge clk);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Check (255 + 5)", test_num);
            reset_dut();
            D1 = 8'd255;
            D2 = 8'd5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition", test_num);
            reset_dut();
            D1 = 8'd0;
            D2 = 8'd0;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Disable Persistence", test_num);
            reset_dut();

            D1 = 8'd50;
            D2 = 8'd50;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            D1 = 8'd100;
            D2 = 8'd100;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            D1 = 8'd128;
            D2 = 8'd128;
            load = 1;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;
            load = 0;
            @(posedge clk);

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values (255 + 255)", test_num);
            reset_dut();
            D1 = 8'hFF;
            D2 = 8'hFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hFE);
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D1, D2, clk, load, rst, Q);
    end

endmodule
