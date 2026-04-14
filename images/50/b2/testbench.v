`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [3:0] dec_wrway_y;
    reg [1:0] way;
    reg we;
    reg [32:0] wr_data;
    wire [32:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .dec_wrway_y(dec_wrway_y),
        .way(way),
        .we(we),
        .wr_data(wr_data),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            wr_data = 0;
            way = 0;
            dec_wrway_y = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read back");

            addr = 7'h05;
            way = 2'b00;
            dec_wrway_y = 4'b0001;
            wr_data = 33'h1FFFFFFFF;
            we = 1;

            @(posedge clk);
            #2 we = 0;


            #5 #1;
 check_outputs(33'h1FFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Max address write/read");

            addr = 7'h7F;
            way = 2'b11;
            dec_wrway_y = 4'b1000;
            wr_data = 33'h0AAAAAAAA;
            we = 1;

            @(posedge clk);
            #2 we = 0;

            #5 #1;
 check_outputs(33'h0AAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Write Enable logic check");


            addr = 7'h20;
            way = 2'b01;
            dec_wrway_y = 4'b0010;
            wr_data = 33'h123456789;
            we = 1;
            @(posedge clk);


            #2 we = 0;
            wr_data = 33'h000000000;
            @(posedge clk);

            #5 #1;
 check_outputs(33'h123456789);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Asynchronous read check");


            addr = 7'h0A; way = 2'b00; dec_wrway_y = 4'b0001;
            wr_data = 33'h111111111; we = 1;
            @(posedge clk);


            #2 addr = 7'h0B; wr_data = 33'h222222222;
            @(posedge clk);


            #2 we = 0;
            addr = 7'h0A;
            #1 #1;
 check_outputs(33'h111111111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: 33-bit boundary check");

            addr = 7'h15;
            way = 2'b10;
            dec_wrway_y = 4'b0100;
            wr_data = 33'h100000000;
            we = 1;

            @(posedge clk);
            #2 we = 0;

            #5 #1;
 check_outputs(33'h100000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Cross-way independence check");


            addr = 7'h40; way = 2'b00; dec_wrway_y = 4'b0001;
            wr_data = 33'h111111111; we = 1;
            @(posedge clk);


            #2 way = 2'b01; dec_wrway_y = 4'b0010;
            wr_data = 33'h222222222;
            @(posedge clk);


            #2 we = 0;
            way = 2'b00;
            #1 #1;
 check_outputs(33'h111111111);
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
        input [32:0] expected_rd_data;
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
        $dumpvars(0,addr, clk, dec_wrway_y, way, we, wr_data, rd_data);
    end

endmodule
