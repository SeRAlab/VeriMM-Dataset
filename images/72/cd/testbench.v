`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg reset;
    reg select;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .select(select),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        select = 0;
        data = 8'h00;
        @(posedge clk);
        #1 reset = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Reset state");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Parallel Load 0xAA into 0x00");
        data = 8'hAA;
        select = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        data = 8'hAA; select = 1; @(posedge clk); #1;

        $display("Testcase 003: Parallel Load 0x55 while register is 0xAA");
        data = 8'h55; select = 1; @(posedge clk); #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        data = 8'h80; select = 1; @(posedge clk); #1;

        $display("Testcase 004: Shift 0x80 with data[0]=0");
        data = 8'h00; select = 0; @(posedge clk); #1;


        #1;



        check_outputs(8'hC0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        data = 8'h80; select = 1; @(posedge clk); #1;

        $display("Testcase 005: Shift 0x80 with data[0]=1");
        data = 8'h01; select = 0; @(posedge clk); #1;


        #1;



        check_outputs(8'hC1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();

        data = 8'hF0; select = 1; @(posedge clk); #1;

        data = 8'h00; select = 0; @(posedge clk); #1;

        data = 8'h01; select = 0; @(posedge clk); #1;
        $display("Testcase 006: Multi-step shift sequence");


        #1;



        check_outputs(8'hFD);
    end
        endtask

    task testcase007;

    begin
        reset_dut();

        data = 8'hAA; select = 1; @(posedge clk); #1;
        data = 8'h00; select = 0; @(posedge clk); #1;

        $display("Testcase 007: Load 0x2B into shifted register 0xD4");
        data = 8'h2B; select = 1; @(posedge clk); #1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, reset, select, q);
    end

endmodule
