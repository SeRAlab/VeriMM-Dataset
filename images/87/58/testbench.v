`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [5:0] rd_addr;
    reg rd_en;
    reg [5:0] wr_addr;
    reg [7:0] wr_data;
    reg wr_en;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .rd_addr(rd_addr),
        .rd_en(rd_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            wr_en = 0;
            rd_en = 0;
            wr_addr = 0;
            rd_addr = 0;
            wr_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();


            @(negedge clk);
            en = 1;
            wr_en = 1;
            wr_addr = 6'd10;
            wr_data = 8'hA5;

            @(negedge clk);
            wr_en = 0;


            rd_en = 1;
            rd_addr = 6'd10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simultaneous Write and Read (Different Addresses)");
            reset_dut();


            @(negedge clk);
            en = 1;
            wr_en = 1;
            wr_addr = 6'd20;
            wr_data = 8'h55;

            @(negedge clk);

            wr_en = 1;
            wr_addr = 6'd21;
            wr_data = 8'h66;
            rd_en = 1;
            rd_addr = 6'd20;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Global Enable Signal check");
            reset_dut();


            @(negedge clk);
            en = 0;
            wr_en = 1;
            wr_addr = 6'd5;
            wr_data = 8'hFF;

            @(negedge clk);

            en = 1;
            rd_en = 1;
            rd_addr = 6'd5;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Enable check");
            reset_dut();


            @(negedge clk);
            en = 1;
            wr_en = 0;
            wr_addr = 6'd32;
            wr_data = 8'h12;

            @(negedge clk);

            rd_en = 1;
            rd_addr = 6'd32;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Max Address check (63)");
            reset_dut();


            @(negedge clk);
            en = 1;
            wr_en = 1;
            wr_addr = 6'd63;
            wr_data = 8'hE7;

            @(negedge clk);
            wr_en = 0;
            rd_en = 1;
            rd_addr = 6'd63;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hE7);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verifying multiple memory locations");
            reset_dut();

            en = 1;
            wr_en = 1;


            @(negedge clk); wr_addr = 6'd1; wr_data = 8'h01;
            @(negedge clk); wr_addr = 6'd2; wr_data = 8'h02;
            @(negedge clk); wr_addr = 6'd3; wr_data = 8'h03;

            @(negedge clk);
            wr_en = 0;
            rd_en = 1;
            rd_addr = 6'd2;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h02);
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
        input [7:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,clk, en, rd_addr, rd_en, wr_addr, wr_data, wr_en, rd_data);
    end

endmodule
