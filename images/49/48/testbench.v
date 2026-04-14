`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg rd_en;
    reg rst;
    reg [7:0] wr_data;
    reg wr_en;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .rd_en(rd_en),
        .rst(rst),
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
            rst = 1;
            addr = 0;
            wr_en = 0;
            wr_data = 0;
            rd_en = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            addr = 16'h1234;
            wr_data = 8'hA5;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);


            addr = 16'h1234;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;


            @(posedge clk);

            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            addr = 16'h0001;
            wr_data = 8'h11;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            addr = 16'hFFFF;
            wr_data = 8'hFF;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            addr = 16'h0001;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            $display("Testcase %0d: Multiple Addresses (Read 1)", test_num);
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            addr = 16'h5555;
            wr_data = 8'hAA;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            addr = 16'h5555;
            wr_data = 8'hBB;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            addr = 16'h5555;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            $display("Testcase %0d: Overwrite Data", test_num);
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            addr = 16'hDEAD;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            $display("Testcase %0d: Read Uninitialized", test_num);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clk);
            addr = 16'h8888;
            wr_data = 8'h88;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            repeat(5) @(posedge clk);


            addr = 16'h8888;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            $display("Testcase %0d: Persistence After IDLE", test_num);
            #1;

            check_outputs(8'h88);
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
        $dumpvars(0,addr, clk, rd_en, rst, wr_data, wr_en, rd_data);
    end

endmodule
