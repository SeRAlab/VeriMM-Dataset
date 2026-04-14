`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] rd_addr;
    reg rd_enable;
    reg [3:0] wr_addr;
    reg [7:0] wr_data;
    reg wr_enable;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_addr(rd_addr),
        .rd_enable(rd_enable),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_enable(wr_enable),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rd_enable = 0;
        wr_enable = 0;
        rd_addr = 0;
        wr_addr = 0;
        wr_data = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read at Address 0", test_num);
        reset_dut();


        wr_enable = 1;
        wr_addr = 4'h0;
        wr_data = 8'hA5;
        @(negedge clk);
        wr_enable = 0;


        rd_enable = 1;
        rd_addr = 4'h0;
        @(negedge clk);

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Write and Read at Max Address (15)", test_num);
        reset_dut();


        wr_enable = 1;
        wr_addr = 4'hF;
        wr_data = 8'h5A;
        @(negedge clk);
        wr_enable = 0;


        rd_enable = 1;
        rd_addr = 4'hF;
        @(negedge clk);

        #1;


        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Verify wr_enable disabled check", test_num);
        reset_dut();


        wr_enable = 1;
        wr_addr = 4'h5;
        wr_data = 8'h11;
        @(negedge clk);


        wr_enable = 0;
        wr_addr = 4'h5;
        wr_data = 8'hEE;
        @(negedge clk);


        rd_enable = 1;
        rd_addr = 4'h5;
        @(negedge clk);

        #1;


        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Overwrite data at same address", test_num);
        reset_dut();


        wr_enable = 1;
        wr_addr = 4'h2;
        wr_data = 8'h33;
        @(negedge clk);


        wr_data = 8'h44;
        @(negedge clk);
        wr_enable = 0;


        rd_enable = 1;
        rd_addr = 4'h2;
        @(negedge clk);

        #1;


        check_outputs(8'h44);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Multi-address write integrity check", test_num);
        reset_dut();


        wr_enable = 1;
        wr_addr = 4'h1;
        wr_data = 8'hAA;
        @(negedge clk);


        wr_addr = 4'h2;
        wr_data = 8'hBB;
        @(negedge clk);
        wr_enable = 0;


        rd_enable = 1;
        rd_addr = 4'h1;
        @(negedge clk);

        #1;


        check_outputs(8'hAA);
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
        $dumpvars(0,clk, rd_addr, rd_enable, wr_addr, wr_data, wr_enable, rd_data);
    end

endmodule
