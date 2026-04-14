`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr1;
    reg [2:0] addr2;
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [7:0] data1;
    wire [7:0] data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .data1(data1),
        .data2(data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            rd_en = 0;
            addr1 = 0;
            addr2 = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            wr_en <= 1;
            addr1 <= 3'd0;
            data_in <= 8'hAA;
            @(posedge clk);
            wr_en <= 0;


            rd_en <= 1;
            addr1 <= 3'd0;
            addr2 <= 3'd1;

            #5;
            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            wr_en <= 1;
            addr1 <= 3'd7;
            data_in <= 8'h55;
            @(posedge clk);
            wr_en <= 0;


            rd_en <= 1;
            addr1 <= 3'd7;
            addr2 <= 3'd7;

            #5;
            $display("Testcase 002: Max Address Write/Read");
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            wr_en <= 1;
            addr1 <= 3'd2;
            data_in <= 8'hFF;
            @(posedge clk);
            wr_en <= 0;


            rd_en <= 0;
            addr1 <= 3'd2;
            addr2 <= 3'd2;

            #5;
            $display("Testcase 003: Read Enable Low (Expect 0)");
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            wr_en <= 1;
            addr1 <= 3'd1;
            data_in <= 8'h11;
            @(posedge clk);

            wr_en <= 1;
            addr1 <= 3'd2;
            data_in <= 8'h22;
            @(posedge clk);
            wr_en <= 0;


            rd_en <= 1;
            addr1 <= 3'd1;
            addr2 <= 3'd2;

            #5;
            $display("Testcase 004: Dual Port Read");
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clk);
            wr_en <= 1;
            addr1 <= 3'd4;
            data_in <= 8'hDE;
            @(posedge clk);

            wr_en <= 1;
            addr1 <= 3'd4;
            data_in <= 8'hAD;
            @(posedge clk);
            wr_en <= 0;


            rd_en <= 1;
            addr1 <= 3'd4;
            addr2 <= 3'd4;

            #5;
            $display("Testcase 005: Overwrite check");
            #1;

            check_outputs(8'hAD, 8'hAD);
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
        input [7:0] expected_data1;
        input [7:0] expected_data2;
        begin
            if (expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data2 === (expected_data2 ^ data2 ^ expected_data2)) begin
                $display("PASS");
                $display("  Outputs: data1=%h, data2=%h",
                         data1, data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data1=%h, data2=%h",
                         expected_data1, expected_data2);
                $display("  Got:      data1=%h, data2=%h",
                         data1, data2);
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
        $dumpvars(0,addr1, addr2, clk, data_in, rd_en, wr_en, data1, data2);
    end

endmodule
