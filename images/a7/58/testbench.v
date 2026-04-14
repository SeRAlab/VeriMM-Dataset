`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d1;
    reg [7:0] d2;
    reg reset;
    reg select;
    wire [7:0] q_active;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .reset(reset),
        .select(select),
        .q_active(q_active),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d1 = 0;
            d2 = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'h00, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            d1 = 8'hA5;
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 16'hA500);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            d2 = 8'h5A;
            select = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h5A, 16'h005A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            d1 = 8'h12;
            select = 0;
            @(posedge clk);
            #1;

            d2 = 8'h34;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h34, 16'h1234);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            d2 = 8'hFF;
            select = 1;

            @(posedge clk);

            d2 = 8'hEE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE, 16'h00EE);
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
        input [7:0] expected_q_active;
        input [15:0] expected_result;
        begin
            if (expected_q_active === (expected_q_active ^ q_active ^ expected_q_active) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: q_active=%h, result=%h",
                         q_active, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_active=%h, result=%h",
                         expected_q_active, expected_result);
                $display("  Got:      q_active=%h, result=%h",
                         q_active, result);
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
        $dumpvars(0,clk, d1, d2, reset, select, q_active, result);
    end

endmodule
