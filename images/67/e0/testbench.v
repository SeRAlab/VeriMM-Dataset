`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] clcount;
    reg clk;
    reg [7:0] enable;
    reg switch;
    reg [9:0] tor_x;
    reg [8:0] tor_y;
    wire outtd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clcount(clcount),
        .clk(clk),
        .enable(enable),
        .switch(switch),
        .tor_x(tor_x),
        .tor_y(tor_y),
        .outtd(outtd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clcount = 2'b00;
            switch  = 1'b0;
            enable  = 8'h00;
            tor_x   = 10'd0;
            tor_y   = 9'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            clcount = 2'b01;
            switch  = 1'b1;
            enable  = 8'hFF;
            tor_x   = 10'd300;
            tor_y   = 9'd225;
            @(posedge clk);
            #2;
            $display("Test 001: Inside Rectangle, clcount=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            clcount = 2'b00;
            switch  = 1'b1;
            enable  = 8'hFF;
            tor_x   = 10'd300;
            tor_y   = 9'd225;
            @(posedge clk);
            #2;
            $display("Test 002: Inside Rectangle, clcount=0 (Expected Low)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            clcount = 2'b01;
            switch  = 1'b1;
            enable  = 8'hFF;
            tor_x   = 10'd50;
            tor_y   = 9'd225;
            @(posedge clk);
            #2;
            $display("Test 003: Outside X-Range (Expected Low)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            clcount = 2'b01;
            switch  = 1'b1;
            enable  = 8'hFF;
            tor_x   = 10'd300;
            tor_y   = 9'd450;
            @(posedge clk);
            #2;
            $display("Test 004: Outside Y-Range (Expected Low)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            clcount = 2'b01;
            switch  = 1'b1;
            enable  = 8'hFF;

            tor_x   = 10'd200;
            tor_y   = 9'd150;
            @(posedge clk);
            #2;
            $display("Test 005: Boundary Check");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            clcount = 2'b10;
            switch  = 1'b1;
            enable  = 8'hFF;
            tor_x   = 10'd300;
            tor_y   = 9'd225;
            @(posedge clk);
            #2;
            $display("Test 006: Inside Rectangle, clcount=2 (Expected Low)");
            #1;

            check_outputs(1'b0);
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
        input expected_outtd;
        begin
            if (expected_outtd === (expected_outtd ^ outtd ^ expected_outtd)) begin
                $display("PASS");
                $display("  Outputs: outtd=%b",
                         outtd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outtd=%b",
                         expected_outtd);
                $display("  Got:      outtd=%b",
                         outtd);
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
        $dumpvars(0,clcount, clk, enable, switch, tor_x, tor_y, outtd);
    end

endmodule
