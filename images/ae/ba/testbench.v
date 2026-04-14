`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] dataA_d;
    reg [3:0] dataB_d;
    reg reset_L_d;
    reg [1:0] sum10;
    wire [3:0] dataA_dd;
    wire [3:0] dataB_dd;
    wire [1:0] reset_L_dd;
    wire [1:0] sum10_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataA_d(dataA_d),
        .dataB_d(dataB_d),
        .reset_L_d(reset_L_d),
        .sum10(sum10),
        .dataA_dd(dataA_dd),
        .dataB_dd(dataB_dd),
        .reset_L_dd(reset_L_dd),
        .sum10_d(sum10_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dataA_d = 4'b0;
            dataB_d = 4'b0;
            sum10 = 2'b0;
            reset_L_d = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Capture (Patterns 5 and A)", test_num);
            reset_dut();
            dataA_d = 4'h5;
            dataB_d = 4'hA;
            sum10 = 2'b01;
            reset_L_d = 1'b1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h5, 4'hA, 2'h1, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Boundary Values (All 1s and All 0s)", test_num);
            reset_dut();
            dataA_d = 4'hF;
            dataB_d = 4'h0;
            sum10 = 2'b11;
            reset_L_d = 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 4'h0, 2'h0, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Stability between Clock Edges", test_num);
            reset_dut();


            dataA_d = 4'h3;
            dataB_d = 4'hC;
            sum10 = 2'b10;
            reset_L_d = 1'b1;
            @(posedge clk);
            #2;


            dataA_d = 4'h0;
            dataB_d = 4'h0;
            #2;

            #1;


            check_outputs(4'h3, 4'hC, 2'h1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Walking Bit Patterns", test_num);
            reset_dut();
            dataA_d = 4'b1000;
            dataB_d = 4'b0001;
            sum10 = 2'b00;
            reset_L_d = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1000, 4'b0001, 2'h1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Final Capture Verification", test_num);
            reset_dut();
            dataA_d = 4'h7;
            dataB_d = 4'h8;
            sum10 = 2'b11;
            reset_L_d = 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h7, 4'h8, 2'h0, 2'b11);
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
        input [3:0] expected_dataA_dd;
        input [3:0] expected_dataB_dd;
        input [1:0] expected_reset_L_dd;
        input [1:0] expected_sum10_d;
        begin
            if (expected_dataA_dd === (expected_dataA_dd ^ dataA_dd ^ expected_dataA_dd) &&
                expected_dataB_dd === (expected_dataB_dd ^ dataB_dd ^ expected_dataB_dd) &&
                expected_reset_L_dd === (expected_reset_L_dd ^ reset_L_dd ^ expected_reset_L_dd) &&
                expected_sum10_d === (expected_sum10_d ^ sum10_d ^ expected_sum10_d)) begin
                $display("PASS");
                $display("  Outputs: dataA_dd=%h, dataB_dd=%h, reset_L_dd=%h, sum10_d=%h",
                         dataA_dd, dataB_dd, reset_L_dd, sum10_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataA_dd=%h, dataB_dd=%h, reset_L_dd=%h, sum10_d=%h",
                         expected_dataA_dd, expected_dataB_dd, expected_reset_L_dd, expected_sum10_d);
                $display("  Got:      dataA_dd=%h, dataB_dd=%h, reset_L_dd=%h, sum10_d=%h",
                         dataA_dd, dataB_dd, reset_L_dd, sum10_d);
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
        $dumpvars(0,clk, dataA_d, dataB_d, reset_L_d, sum10, dataA_dd, dataB_dd, reset_L_dd, sum10_d);
    end

endmodule
