`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write to Reg 0 and 1", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 4'd0; wr_data = 8'hA5;
            @(posedge clk); #1;


            wr_en = 1; wr_addr = 4'd1; wr_data = 8'h5A;
            @(posedge clk); #1;

            wr_en = 0;
            #1;

            check_outputs(8'hA5, 8'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable functionality", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 4'd0; wr_data = 8'h11;
            @(posedge clk); #1;
            wr_en = 1; wr_addr = 4'd1; wr_data = 8'h22;
            @(posedge clk); #1;


            wr_en = 0; wr_addr = 4'd0; wr_data = 8'hFF;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting existing data", test_num);
            reset_dut();

            wr_en = 1; wr_addr = 4'd0; wr_data = 8'hAA;
            @(posedge clk); #1;
            wr_en = 1; wr_addr = 4'd0; wr_data = 8'hBB;
            @(posedge clk); #1;

            wr_en = 1; wr_addr = 4'd1; wr_data = 8'hCC;
            @(posedge clk); #1;

            wr_en = 0;
            #1;

            check_outputs(8'hBB, 8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write to non-output registers", test_num);
            reset_dut();


            wr_en = 1; wr_addr = 4'd0; wr_data = 8'h00;
            @(posedge clk); #1;
            wr_en = 1; wr_addr = 4'd1; wr_data = 8'h00;
            @(posedge clk); #1;


            wr_en = 1; wr_addr = 4'd5; wr_data = 8'hFF;
            @(posedge clk); #1;
            wr_en = 1; wr_addr = 4'd15; wr_data = 8'hEE;
            @(posedge clk); #1;

            wr_en = 0;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary data values", test_num);
            reset_dut();

            wr_en = 1; wr_addr = 4'd0; wr_data = 8'hFF;
            @(posedge clk); #1;
            wr_en = 1; wr_addr = 4'd1; wr_data = 8'h00;
            @(posedge clk); #1;

            wr_en = 0;
            #1;

            check_outputs(8'hFF, 8'h00);
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
        $dumpvars(0,clk, wr_addr, wr_data, wr_en, rd_data1, rd_data2);
    end

endmodule
