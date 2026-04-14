`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg [3:0] dly;
    reg rst;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .dly(dly),
        .rst(rst),
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
        din = 0;
        dly = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Check - Ensuring register is zeroed", test_num);
        reset_dut();

        dly = 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Delay 0 Check - Data should appear in first stage", test_num);
        reset_dut();
        din = 1'b1;
        dly = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Delay Check (dly=15)", test_num);
        reset_dut();


        din = 1'b1;
        @(posedge clk);
        din = 1'b0;
        for(i = 0; i < 15; i = i + 1) begin
            @(posedge clk);
        end


        dly = 4'd15;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern check at Delay 7", test_num);
        reset_dut();



        din = 1'b1; @(posedge clk);
        din = 1'b0; @(posedge clk);
        din = 1'b0; @(posedge clk);
        din = 1'b1; @(posedge clk);
        din = 1'b0; @(posedge clk);
        din = 1'b0; @(posedge clk);
        din = 1'b0; @(posedge clk);
        din = 1'b1; @(posedge clk);

        dly = 4'd7;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dynamic Delay Selection Check", test_num);
        reset_dut();


        din = 1'b1; @(posedge clk);
        din = 1'b0; @(posedge clk);
        din = 1'b1; @(posedge clk);


        dly = 4'd2;
        #1;
        if (dout === 1'b1) begin

            dly = 4'd1;
            #1;
            #1;

            check_outputs(1'b0);
        end else begin
            #1;

            check_outputs(1'b1);
        end
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, din, dly, rst, dout);
    end

endmodule
