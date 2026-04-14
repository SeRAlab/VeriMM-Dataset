`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg clk_ena_job;
    reg [7:0] dfload;
    reg load;
    reg rst;
    wire carry;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .clk_ena_job(clk_ena_job),
        .dfload(dfload),
        .load(load),
        .rst(rst),
        .carry(carry),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_ena = 0;
            clk_ena_job = 0;
            load = 0;
            dfload = 8'hFF;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing when both enables are active", test_num);
            reset_dut();
            clk_ena = 1;
            clk_ena_job = 1;
            dfload = 8'h0A;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify clk_ena=0 blocks counting", test_num);
            reset_dut();
            clk_ena = 0;
            clk_ena_job = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify clk_ena_job=0 blocks counting", test_num);
            reset_dut();
            clk_ena = 1;
            clk_ena_job = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0 (load=1, job_ena=0)", test_num);
            reset_dut();

            clk_ena = 1; clk_ena_job = 1;
            repeat(2) @(posedge clk);

            load = 1;
            clk_ena_job = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 1 (load=1, job_ena=1)", test_num);
            reset_dut();
            load = 1;
            clk_ena_job = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry output at dfload modulus", test_num);
            reset_dut();
            dfload = 8'h05;
            clk_ena = 1;
            clk_ena_job = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 8'h05);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap back to 0 after modulus", test_num);
            reset_dut();
            dfload = 8'h02;
            clk_ena = 1;
            clk_ena_job = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load priority over enable", test_num);
            reset_dut();
            clk_ena = 1;
            clk_ena_job = 1;
            @(posedge clk);
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 8'h01);
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
        testcase008();
        testcase009();
        
        
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
        input expected_carry;
        input [7:0] expected_dout;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, dout=%h",
                         carry, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, dout=%h",
                         expected_carry, expected_dout);
                $display("  Got:      carry=%b, dout=%h",
                         carry, dout);
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
        $dumpvars(0,clk, clk_ena, clk_ena_job, dfload, load, rst, carry, dout);
    end

endmodule
