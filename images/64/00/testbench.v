`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg WE;
    reg clk;
    reg clr;
    reg [31:0] datain;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WE(WE),
        .clk(clk),
        .clr(clr),
        .datain(datain),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            WE = 0;
            datain = 0;
            @(posedge clk);
            #1 clr = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial Reset Check");
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write Data with WE=1");
            reset_dut();
            datain = 32'hDEADBEEF;
            WE = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Maintain Data with WE=0");
            reset_dut();

            datain = 32'hAAAA5555;
            WE = 1;
            @(posedge clk);

            #1;
            datain = 32'h12345678;
            WE = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Clear while holding data");
            reset_dut();

            datain = 32'hFFFFFFFF;
            WE = 1;
            @(posedge clk);
            #1;

            clr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
            clr = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Simultaneous WE and Clear");
            reset_dut();
            datain = 32'hBCBCBCBC;
            WE = 1;
            clr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
            clr = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Consecutive Writes");
            reset_dut();
            WE = 1;
            datain = 32'h1;
            @(posedge clk);
            #1;
            datain = 32'h2;
            @(posedge clk);
            #1;
            datain = 32'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h3);
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
        input [31:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,WE, clk, clr, datain, dataout);
    end

endmodule
