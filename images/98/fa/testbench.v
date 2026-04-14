`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] add;
    reg clk;
    reg reset;
    wire [63:0] cont;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .clk(clk),
        .reset(reset),
        .cont(cont)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            add = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            add = 64'd0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(64'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            add = 64'hABC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hABC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            add = 64'd10;
            @(posedge clk);
            add = 64'd20;
            @(posedge clk);
            add = 64'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd35);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            add = 64'd0;
            @(posedge clk);
            @(posedge clk);
            add = 64'd100;
            @(posedge clk);
            add = 64'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd103);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            add = 64'hF000_0000_0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hF000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            add = 64'd50;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd0);
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
        input [63:0] expected_cont;
        begin
            if (expected_cont === (expected_cont ^ cont ^ expected_cont)) begin
                $display("PASS");
                $display("  Outputs: cont=%h",
                         cont);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cont=%h",
                         expected_cont);
                $display("  Got:      cont=%h",
                         cont);
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
        $dumpvars(0,add, clk, reset, cont);
    end

endmodule
