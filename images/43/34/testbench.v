`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DATA_IN;
    reg LD_EN;
    reg SH_EN;
    reg clk;
    wire [7:0] PAR_OUT;
    wire [7:0] SER_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .LD_EN(LD_EN),
        .SH_EN(SH_EN),
        .clk(clk),
        .PAR_OUT(PAR_OUT),
        .SER_OUT(SER_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            LD_EN = 0;
            SH_EN = 0;
            DATA_IN = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            DATA_IN = 8'hAA;
            LD_EN = 1;
            SH_EN = 0;
            @(posedge clk);
            #1;
            LD_EN = 0;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            DATA_IN = 8'h55;
            LD_EN = 1;
            SH_EN = 0;
            @(posedge clk);
            #1;
            LD_EN = 0;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            DATA_IN = 8'hFF;
            LD_EN = 1;
            @(posedge clk);
            #1;
            DATA_IN = 8'h00;
            LD_EN = 1;
            @(posedge clk);
            #1;
            LD_EN = 0;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            DATA_IN = 8'h80;
            LD_EN = 1;
            @(posedge clk);
            #1;

            LD_EN = 0;
            SH_EN = 1;
            @(posedge clk);
            #1;
            SH_EN = 0;

            #1;


            check_outputs(8'h01, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            DATA_IN = 8'h0F;
            LD_EN = 1;
            @(posedge clk);
            #1;

            DATA_IN = 8'hF0;
            LD_EN = 1;
            SH_EN = 1;
            @(posedge clk);
            #1;
            LD_EN = 0;
            SH_EN = 0;

            #1;


            check_outputs(8'hF0, 8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            DATA_IN = 8'hA5;
            LD_EN = 1;
            @(posedge clk);
            #1;
            LD_EN = 0;
            SH_EN = 0;
            DATA_IN = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
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
        input [7:0] expected_PAR_OUT;
        input [7:0] expected_SER_OUT;
        begin
            if (expected_PAR_OUT === (expected_PAR_OUT ^ PAR_OUT ^ expected_PAR_OUT) &&
                expected_SER_OUT === (expected_SER_OUT ^ SER_OUT ^ expected_SER_OUT)) begin
                $display("PASS");
                $display("  Outputs: PAR_OUT=%h, SER_OUT=%h",
                         PAR_OUT, SER_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PAR_OUT=%h, SER_OUT=%h",
                         expected_PAR_OUT, expected_SER_OUT);
                $display("  Got:      PAR_OUT=%h, SER_OUT=%h",
                         PAR_OUT, SER_OUT);
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
        $dumpvars(0,DATA_IN, LD_EN, SH_EN, clk, PAR_OUT, SER_OUT);
    end

endmodule
