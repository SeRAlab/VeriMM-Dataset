`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] alu;
    reg clk;
    reg [3:0] min0;
    reg [3:0] min1;
    reg rst_n;
    reg [3:0] sec0;
    reg [3:0] sec1;
    reg switch;
    wire [3:0] dig1;
    wire [3:0] dig2;
    wire [3:0] dig3;
    wire [3:0] dig4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu(alu),
        .clk(clk),
        .min0(min0),
        .min1(min1),
        .rst_n(rst_n),
        .sec0(sec0),
        .sec1(sec1),
        .switch(switch),
        .dig1(dig1),
        .dig2(dig2),
        .dig3(dig3),
        .dig4(dig4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            init_signals();
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task init_signals;

        begin
            alu = 2'b00;
            min0 = 4'd0;
            min1 = 4'd0;
            sec0 = 4'd0;
            sec1 = 4'd0;
            switch = 1'b0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Update mode with switch ON", test_num);
            reset_dut();
            switch = 1'b1;
            alu = 2'b00;
            min1 = 4'd1; min0 = 4'd2; sec1 = 4'd3; sec0 = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1, 4'd2, 4'd3, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Retention mode (switch OFF, alu 2'b10)", test_num);
            reset_dut();


            switch = 1'b1;
            min1 = 4'd5; min0 = 4'd6; sec1 = 4'd7; sec0 = 4'd8;
            @(posedge clk);
            #2;


            switch = 1'b0;
            alu = 2'b10;
            min1 = 4'd0; min0 = 4'd0; sec1 = 4'd0; sec0 = 4'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd5, 4'd6, 4'd7, 4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Update mode (switch ON overrides alu 2'b10)", test_num);
            reset_dut();

            switch = 1'b1;
            alu = 2'b10;
            min1 = 4'hA; min0 = 4'hB; sec1 = 4'hC; sec0 = 4'hD;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA, 4'hB, 4'hC, 4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Update mode (switch OFF, alu not 2'b10)", test_num);
            reset_dut();

            switch = 1'b0;
            alu = 2'b11;
            min1 = 4'd9; min0 = 4'd9; sec1 = 4'd5; sec0 = 4'd9;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd9, 4'd9, 4'd5, 4'd9);
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
        input [3:0] expected_dig1;
        input [3:0] expected_dig2;
        input [3:0] expected_dig3;
        input [3:0] expected_dig4;
        begin
            if (expected_dig1 === (expected_dig1 ^ dig1 ^ expected_dig1) &&
                expected_dig2 === (expected_dig2 ^ dig2 ^ expected_dig2) &&
                expected_dig3 === (expected_dig3 ^ dig3 ^ expected_dig3) &&
                expected_dig4 === (expected_dig4 ^ dig4 ^ expected_dig4)) begin
                $display("PASS");
                $display("  Outputs: dig1=%h, dig2=%h, dig3=%h, dig4=%h",
                         dig1, dig2, dig3, dig4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dig1=%h, dig2=%h, dig3=%h, dig4=%h",
                         expected_dig1, expected_dig2, expected_dig3, expected_dig4);
                $display("  Got:      dig1=%h, dig2=%h, dig3=%h, dig4=%h",
                         dig1, dig2, dig3, dig4);
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
        $dumpvars(0,alu, clk, min0, min1, rst_n, sec0, sec1, switch, dig1, dig2, dig3, dig4);
    end

endmodule
