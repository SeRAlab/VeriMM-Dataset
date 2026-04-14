`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Cal_Valid;
    reg clk;
    reg [31:0] data;
    reg rst_n;
    reg [7:0] weight;
    wire [31:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cal_Valid(Cal_Valid),
        .clk(clk),
        .data(data),
        .rst_n(rst_n),
        .weight(weight),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            Cal_Valid = 0;
            weight = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd10; data = 32'sd5;
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd5;  data = 32'sd20;
            @(posedge clk);
            #1;
            $display("Testcase 001: Basic positive accumulation");
            #1;

            check_outputs(32'sd150);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            Cal_Valid = 1; weight = -8'sd2; data = 32'sd100;
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd4;  data = -32'sd50;
            @(posedge clk);
            #1;
            $display("Testcase 002: Signed accumulation");
            #1;

            check_outputs(-32'sd400);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd10; data = 32'sd10;
            @(posedge clk);
            Cal_Valid = 0; weight = 8'sd10; data = 32'sd10;
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd7;  data = 32'sd3;
            @(posedge clk);
            #1;
            $display("Testcase 003: Cal_Valid clearing buffer");
            #1;

            check_outputs(32'sd21);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd10; data = 32'sd10;
            @(posedge clk);
            rst_n = 0;
            @(posedge clk);
            rst_n = 1;
            Cal_Valid = 1; weight = 8'sd5;  data = 32'sd5;
            @(posedge clk);
            #1;
            $display("Testcase 004: Reset mid-operation");
            #1;

            check_outputs(32'sd25);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd1; data = 32'h7FFFFFFF;
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd1; data = 32'h00000001;
            @(posedge clk);
            #1;
            $display("Testcase 005: Positive overflow wrap-around");
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            Cal_Valid = 1; weight = 8'sd1;  data = 32'h80000000;
            @(posedge clk);
            Cal_Valid = 1; weight = -8'sd1; data = 32'h00000001;
            @(posedge clk);
            #1;
            $display("Testcase 006: Negative overflow wrap-around");
            #1;

            check_outputs(32'h7FFFFFFF);
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
        input [31:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,Cal_Valid, clk, data, rst_n, weight, Dout);
    end

endmodule
