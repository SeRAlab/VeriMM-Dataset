`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enDOWN;
    reg enUP;
    reg [3:0] en_count;
    reg reset;
    wire [7:0] data_MES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enDOWN(enDOWN),
        .enUP(enUP),
        .en_count(en_count),
        .reset(reset),
        .data_MES(data_MES)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enDOWN = 0;
        enUP = 0;
        en_count = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        en_count = 4'h5;
        enUP = 1;
        @(posedge clk);
        enUP = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        en_count = 4'hA;
        enUP = 1;
        @(posedge clk);
        enUP = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        en_count = 4'h5;
        enUP = 1;
        repeat(10) @(posedge clk);
        enUP = 0;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        en_count = 4'h5;
        enUP = 1;
        repeat(11) @(posedge clk);
        enUP = 0;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        en_count = 4'h5;
        enUP = 1;
        repeat(12) @(posedge clk);
        enUP = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        en_count = 4'h5;
        enDOWN = 1;
        @(posedge clk);
        enDOWN = 0;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        en_count = 4'h5;
        enUP = 1;
        repeat(10) @(posedge clk);
        enUP = 0;
        enDOWN = 1;
        @(posedge clk);
        enDOWN = 0;
        #1;

        check_outputs(8'h09);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        en_count = 4'h5;
        enUP = 0;
        enDOWN = 0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        en_count = 4'h5;
        enUP = 1;
        repeat(11) @(posedge clk);
        enUP = 0;
        enDOWN = 1;
        repeat(2) @(posedge clk);
        enDOWN = 0;
        #1;

        check_outputs(8'h09);
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
        testcase010();
        
        
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
        input [7:0] expected_data_MES;
        begin
            if (expected_data_MES === (expected_data_MES ^ data_MES ^ expected_data_MES)) begin
                $display("PASS");
                $display("  Outputs: data_MES=%h",
                         data_MES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_MES=%h",
                         expected_data_MES);
                $display("  Got:      data_MES=%h",
                         data_MES);
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
        $dumpvars(0,clk, enDOWN, enUP, en_count, reset, data_MES);
    end

endmodule
