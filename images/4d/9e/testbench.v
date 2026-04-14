`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [7:0] data;
    reg rd_en;
    reg wr_en;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd_en = 0;
            wr_en = 0;
            addr = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clk);
            addr <= 10'h000;
            data <= 8'hA5;
            wr_en <= 1;
            rd_en <= 0;

            @(posedge clk);

            wr_en <= 0;
            rd_en <= 1;
            addr <= 10'h000;

            @(posedge clk);
            #2;
            $display("Testcase 001: Basic Write/Read Address 0");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clk);
            addr <= 10'h3FF;
            data <= 8'h5A;
            wr_en <= 1;
            rd_en <= 0;

            @(posedge clk);

            wr_en <= 0;
            rd_en <= 1;
            addr <= 10'h3FF;

            @(posedge clk);
            #2;
            $display("Testcase 002: Maximum Address 1023");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clk);
            addr <= 10'd10;
            data <= 8'h11;
            wr_en <= 1;

            @(posedge clk);

            addr <= 10'd20;
            data <= 8'h22;
            wr_en <= 1;

            @(posedge clk);

            wr_en <= 0;
            rd_en <= 1;
            addr <= 10'd10;

            @(posedge clk);
            #2;
            $display("Testcase 003: Memory Persistence (Read addr 10 after writing 20)");
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            addr <= 10'd50;
            data <= 8'h77;
            wr_en <= 1;

            @(posedge clk);

            addr <= 10'd50;
            data <= 8'hFF;
            wr_en <= 0;

            @(posedge clk);

            rd_en <= 1;

            @(posedge clk);
            #2;
            $display("Testcase 004: Write Enable de-asserted check");
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clk);
            addr <= 10'd100;
            data <= 8'hBB;
            wr_en <= 1;

            @(posedge clk);

            addr <= 10'd200;
            data <= 8'hCC;
            wr_en <= 1;
            rd_en <= 1;


            addr <= 10'd100;

            @(posedge clk);
            #2;
            $display("Testcase 005: Simultaneous Read(100) and Write(200)");
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(posedge clk);
            addr <= 10'd300;
            data <= 8'hEE;
            wr_en <= 1;

            @(posedge clk);

            wr_en <= 0;
            rd_en <= 0;
            addr <= 10'd300;

            @(posedge clk);
            #2;

            rd_en <= 1;
            @(posedge clk);
            #2;

            $display("Testcase 006: Delayed Read Enable check");
            #1;

            check_outputs(8'hEE);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,addr, clk, data, rd_en, wr_en, q);
    end

endmodule
