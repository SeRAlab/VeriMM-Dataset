`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] rd_addr1;
    reg [1:0] rd_addr2;
    reg reset;
    reg [1:0] wr_addr;
    reg [15:0] wr_data;
    wire [15:0] rd_data1;
    wire [15:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .reset(reset),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
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
            reset = 1;
            rd_addr1 = 0;
            rd_addr2 = 0;
            wr_addr = 0;
            wr_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();


            rd_addr1 = 2'b00;
            rd_addr2 = 2'b01;
            #5;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write/Read Reg 0 & 1", test_num);
            reset_dut();


            wr_addr = 2'b00;
            wr_data = 16'hABCD;
            @(posedge clk);
            #1;


            wr_addr = 2'b01;
            wr_data = 16'h1234;
            @(posedge clk);
            #1;


            rd_addr1 = 2'b00;
            rd_addr2 = 2'b01;
            #5;

            #1;


            check_outputs(16'hABCD, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Write/Read Reg 2 & 3", test_num);
            reset_dut();


            wr_addr = 2'b10;
            wr_data = 16'hFFFF;
            @(posedge clk);
            #1;


            wr_addr = 2'b11;
            wr_data = 16'h55AA;
            @(posedge clk);
            #1;


            rd_addr1 = 2'b10;
            rd_addr2 = 2'b11;
            #5;

            #1;


            check_outputs(16'hFFFF, 16'h55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dual Port Read same address", test_num);
            reset_dut();


            wr_addr = 2'b10;
            wr_data = 16'hCAFE;
            @(posedge clk);
            #1;


            rd_addr1 = 2'b10;
            rd_addr2 = 2'b10;
            #5;

            #1;


            check_outputs(16'hCAFE, 16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite Register", test_num);
            reset_dut();


            wr_addr = 2'b01;
            wr_data = 16'h1111;
            @(posedge clk);
            #1;


            wr_addr = 2'b01;
            wr_data = 16'h2222;
            @(posedge clk);
            #1;


            rd_addr1 = 2'b01;
            rd_addr2 = 2'b00;
            #5;

            #1;


            check_outputs(16'h2222, 16'h0000);
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
        input [15:0] expected_rd_data1;
        input [15:0] expected_rd_data2;
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
        $dumpvars(0,clk, rd_addr1, rd_addr2, reset, wr_addr, wr_data, rd_data1, rd_data2);
    end

endmodule
