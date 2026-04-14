`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] rd_addr1;
    reg [3:0] rd_addr2;
    reg [3:0] wr_addr;
    reg [7:0] wr_data;
    reg wr_en;
    wire [7:0] rd_data1;
    wire [7:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr1 = 0;
            rd_addr2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read-back");
            reset_dut();


            wr_en = 1; wr_addr = 4'h1; wr_data = 8'h55;
            @(posedge clk); #1;


            wr_en = 0;
            rd_addr1 = 4'h1;
            rd_addr2 = 4'h1;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Multiple writes and parallel read");
            reset_dut();


            wr_en = 1; wr_addr = 4'h2; wr_data = 8'hAA;
            @(posedge clk); #1;


            wr_addr = 4'h3; wr_data = 8'hBB;
            @(posedge clk); #1;

            wr_en = 0;

            rd_addr1 = 4'h2;
            rd_addr2 = 4'h3;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hAA, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable logic check");
            reset_dut();


            wr_en = 1; wr_addr = 4'h5; wr_data = 8'h12;
            @(posedge clk); #1;


            wr_en = 0; wr_addr = 4'h5; wr_data = 8'h99;
            @(posedge clk); #1;


            rd_addr1 = 4'h5;
            rd_addr2 = 4'h0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h12, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting a register");
            reset_dut();


            wr_en = 1; wr_addr = 4'hA; wr_data = 8'hCC;
            @(posedge clk); #1;


            wr_addr = 4'hA; wr_data = 8'hDD;
            @(posedge clk); #1;

            wr_en = 0;
            rd_addr1 = 4'hA;
            rd_addr2 = 4'hA;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hDD, 8'hDD);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Highest address boundary check");
            reset_dut();


            wr_en = 1; wr_addr = 4'hF; wr_data = 8'hFF;
            @(posedge clk); #1;

            wr_en = 0;
            rd_addr1 = 4'hF;
            rd_addr2 = 4'hF;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hFF, 8'hFF);
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
        input [7:0] expected_rd_data1;
        input [7:0] expected_rd_data2;
        begin
            if (expected_rd_data1 === (expected_rd_data1 ^ rd_data1 ^ expected_rd_data1) &&
                expected_rd_data2 === (expected_rd_data2 ^ rd_data2 ^ expected_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data1=%h, rd_data2=%h",
                         expected_rd_data1, expected_rd_data2);
                $display("  Got:      rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
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
        $dumpvars(0,clk, rd_addr1, rd_addr2, wr_addr, wr_data, wr_en, rd_data1, rd_data2);
    end

endmodule
