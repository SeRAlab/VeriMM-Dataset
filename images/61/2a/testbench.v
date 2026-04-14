`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] max_val;
    reg rst;
    wire [7:0] rand_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .max_val(max_val),
        .rst(rst),
        .rand_num(rand_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            max_val = 8'hFF;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small max_val constraint (max_val=7)", test_num);
            reset_dut();
            max_val = 8'd7;
            repeat(10) @(posedge clk);
            #1;
            if (rand_num <= 8'd7)
                #1;

                check_outputs(rand_num);
            else
                #1;

                check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero max_val constraint", test_num);
            reset_dut();
            max_val = 8'd0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full range constraint (max_val=255)", test_num);
            reset_dut();
            max_val = 8'hFF;
            repeat(20) @(posedge clk);
            #1;
            if (rand_num <= 8'hFF)
                #1;

                check_outputs(rand_num);
            else
                #1;

                check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dynamic max_val update (change 200 -> 20)", test_num);
            reset_dut();
            max_val = 8'd200;
            repeat(5) @(posedge clk);
            max_val = 8'd20;
            repeat(5) @(posedge clk);
            #1;
            if (rand_num <= 8'd20)
                #1;

                check_outputs(rand_num);
            else
                #1;

                check_outputs(8'd21);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary max_val=1 check", test_num);
            reset_dut();
            max_val = 8'd1;
            repeat(10) @(posedge clk);
            #1;
            if (rand_num <= 8'd1)
                #1;

                check_outputs(rand_num);
            else
                #1;

                check_outputs(8'd2);
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
        input [7:0] expected_rand_num;
        begin
            if (expected_rand_num === (expected_rand_num ^ rand_num ^ expected_rand_num)) begin
                $display("PASS");
                $display("  Outputs: rand_num=%h",
                         rand_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_num=%h",
                         expected_rand_num);
                $display("  Got:      rand_num=%h",
                         rand_num);
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
        $dumpvars(0,clk, max_val, rst, rand_num);
    end

endmodule
