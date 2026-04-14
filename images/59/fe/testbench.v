`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] load;
    reg rst;
    reg set;
    wire [3:0] Q;
    wire [3:0] Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .rst(rst),
        .set(set),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            set = 0;
            rst = 0;
            load = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            set = 1;
            #2;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            set = 1;
            #2;
            set = 0;
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            rst = 1;
            set = 0;
            load = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            rst = 1;
            load = 4'h7;
            @(posedge clk);
            #1;

            load = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7, 4'h8);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            rst = 0;
            load = 4'hE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            rst = 0;
            load = 4'h5;
            #2;
            set = 1;
            #1;

            #1;


            check_outputs(4'hF, 4'h0);
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
        input [3:0] expected_Q;
        input [3:0] expected_Qn;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Qn=%h",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Qn=%h",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%h, Qn=%h",
                         Q, Qn);
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
        $dumpvars(0,clk, load, rst, set, Q, Qn);
    end

endmodule
