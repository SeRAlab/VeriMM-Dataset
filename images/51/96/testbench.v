`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] CA;
    reg [3:0] CB;
    reg clk_in;
    wire [7:0] deciout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CA(CA),
        .CB(CB),
        .clk_in(clk_in),
        .deciout(deciout)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            CA = 4'b0;
            CB = 4'b0;
            @(posedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            CB = 4'd0;
            @(posedge clk_in);
            #2;
            $display("Test Case %0d: CB=0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            CB = 4'd1;
            @(posedge clk_in);
            #2;
            $display("Test Case %0d: CB=1", test_num);
            #1;

            check_outputs(8'd11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            CB = 4'd5;
            @(posedge clk_in);
            #2;
            $display("Test Case %0d: CB=5", test_num);
            #1;

            check_outputs(8'd55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            CB = 4'd9;
            @(posedge clk_in);
            #2;
            $display("Test Case %0d: CB=9", test_num);
            #1;

            check_outputs(8'd99);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            CB = 4'd10;
            @(posedge clk_in);
            #2;
            $display("Test Case %0d: CB=10", test_num);
            #1;

            check_outputs(8'd110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            CB = 4'd15;
            @(posedge clk_in);
            #2;
            $display("Test Case %0d: CB=15", test_num);
            #1;

            check_outputs(8'd165);
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
        input [7:0] expected_deciout;
        begin
            if (expected_deciout === (expected_deciout ^ deciout ^ expected_deciout)) begin
                $display("PASS");
                $display("  Outputs: deciout=%h",
                         deciout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deciout=%h",
                         expected_deciout);
                $display("  Got:      deciout=%h",
                         deciout);
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
        $dumpvars(0,CA, CB, clk_in, deciout);
    end

endmodule
