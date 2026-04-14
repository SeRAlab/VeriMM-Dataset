`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] master_readdata;
    reg master_waitrequest;
    reg reset;
    reg [1:0] slave_address;
    reg [3:0] slave_byteenable;
    reg slave_read;
    reg slave_write;
    reg [31:0] slave_writedata;
    wire [1:0] master_address;
    wire [3:0] master_byteenable;
    wire master_read;
    wire master_write;
    wire [31:0] master_writedata;
    wire [31:0] slave_readdata;
    wire slave_waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .master_readdata(master_readdata),
        .master_waitrequest(master_waitrequest),
        .reset(reset),
        .slave_address(slave_address),
        .slave_byteenable(slave_byteenable),
        .slave_read(slave_read),
        .slave_write(slave_write),
        .slave_writedata(slave_writedata),
        .master_address(master_address),
        .master_byteenable(master_byteenable),
        .master_read(master_read),
        .master_write(master_write),
        .master_writedata(master_writedata),
        .slave_readdata(slave_readdata),
        .slave_waitrequest(slave_waitrequest)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        slave_address = 0;
        slave_byteenable = 0;
        slave_read = 0;
        slave_write = 0;
        slave_writedata = 0;
        master_readdata = 0;
        master_waitrequest = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(2'b00, 4'h0, 1'b0, 1'b0, 32'h0, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        slave_address = 2'b01;
        slave_byteenable = 4'hF;
        slave_write = 1;
        slave_writedata = 32'hABCDE123;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b01, 4'hF, 1'b0, 1'b1, 32'hABCDE123, 32'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        slave_address = 2'b10;
        slave_byteenable = 4'hF;
        slave_write = 1;
        slave_writedata = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b10, 4'hF, 1'b0, 1'b1, 32'hFFFFFFFC, 32'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        slave_address = 2'b11;
        slave_byteenable = 4'hF;
        slave_read = 1;
        master_readdata = 32'h55AA55AA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b11, 4'hF, 1'b1, 1'b0, 32'h0, 32'h55AA55AA, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        slave_address = 2'b01;
        slave_write = 1;
        slave_writedata = 32'h11223344;
        master_waitrequest = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b01, 4'h0, 1'b0, 1'b1, 32'h11223344, 32'h0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        slave_address = 2'b00;
        slave_read = 1;
        master_readdata = 32'h87654321;
        @(posedge clk);
        #1;

        #1;


        check_outputs(2'b00, 4'h0, 1'b1, 1'b0, 32'h0, 32'h87654320, 1'b0);
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
        input [1:0] expected_master_address;
        input [3:0] expected_master_byteenable;
        input expected_master_read;
        input expected_master_write;
        input [31:0] expected_master_writedata;
        input [31:0] expected_slave_readdata;
        input expected_slave_waitrequest;
        begin
            if (expected_master_address === (expected_master_address ^ master_address ^ expected_master_address) &&
                expected_master_byteenable === (expected_master_byteenable ^ master_byteenable ^ expected_master_byteenable) &&
                expected_master_read === (expected_master_read ^ master_read ^ expected_master_read) &&
                expected_master_write === (expected_master_write ^ master_write ^ expected_master_write) &&
                expected_master_writedata === (expected_master_writedata ^ master_writedata ^ expected_master_writedata) &&
                expected_slave_readdata === (expected_slave_readdata ^ slave_readdata ^ expected_slave_readdata) &&
                expected_slave_waitrequest === (expected_slave_waitrequest ^ slave_waitrequest ^ expected_slave_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: master_address=%h, master_byteenable=%h, master_read=%b, master_write=%b, master_writedata=%h, slave_readdata=%h, slave_waitrequest=%b",
                         master_address, master_byteenable, master_read, master_write, master_writedata, slave_readdata, slave_waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: master_address=%h, master_byteenable=%h, master_read=%b, master_write=%b, master_writedata=%h, slave_readdata=%h, slave_waitrequest=%b",
                         expected_master_address, expected_master_byteenable, expected_master_read, expected_master_write, expected_master_writedata, expected_slave_readdata, expected_slave_waitrequest);
                $display("  Got:      master_address=%h, master_byteenable=%h, master_read=%b, master_write=%b, master_writedata=%h, slave_readdata=%h, slave_waitrequest=%b",
                         master_address, master_byteenable, master_read, master_write, master_writedata, slave_readdata, slave_waitrequest);
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
        $dumpvars(0,clk, master_readdata, master_waitrequest, reset, slave_address, slave_byteenable, slave_read, slave_write, slave_writedata, master_address, master_byteenable, master_read, master_write, master_writedata, slave_readdata, slave_waitrequest);
    end

endmodule
