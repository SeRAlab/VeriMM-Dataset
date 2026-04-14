`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] atb_readdata;
    reg clk;
    reg reset;
    reg [5:0] slave_address;
    reg slave_read;
    reg slave_write;
    reg [15:0] slave_writedata;
    wire atb_read;
    wire [5:0] atb_register;
    wire atb_write;
    wire [15:0] atb_writedata;
    wire [15:0] slave_readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .atb_readdata(atb_readdata),
        .clk(clk),
        .reset(reset),
        .slave_address(slave_address),
        .slave_read(slave_read),
        .slave_write(slave_write),
        .slave_writedata(slave_writedata),
        .atb_read(atb_read),
        .atb_register(atb_register),
        .atb_write(atb_write),
        .atb_writedata(atb_writedata),
        .slave_readdata(slave_readdata)
    );
    task testcase001;

    begin
        $display("Running testcase001: Reset and Idle State");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Simple Write Operation");
        test_num = 2;
        reset_dut();

        slave_write = 1;
        slave_address = 6'h0A;
        slave_writedata = 16'hABCD;

        @(posedge clk);

        #1;


        check_outputs(0, 6'h0A, 1, 16'hABCD, 0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Simple Read Operation");
        test_num = 3;
        reset_dut();

        slave_read = 1;
        slave_address = 6'h15;
        atb_readdata = 16'h55AA;

        @(posedge clk);

        #1;


        check_outputs(1, 6'h15, 0, 0, 16'h55AA);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Max Boundary Values");
        test_num = 4;
        reset_dut();

        slave_write = 1;
        slave_address = 6'h3F;
        slave_writedata = 16'hFFFF;

        @(posedge clk);
        #1;

        check_outputs(0, 6'h3F, 1, 16'hFFFF, 0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Read and Write Deassertion");
        test_num = 5;
        reset_dut();


        slave_write = 1;
        slave_address = 6'h01;
        slave_writedata = 16'h1111;
        @(posedge clk);


        slave_write = 0;
        slave_address = 0;
        slave_writedata = 0;
        @(posedge clk);

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Data Integrity on Read Path");
        test_num = 6;
        reset_dut();

        slave_read = 1;
        slave_address = 6'h20;
        atb_readdata = 16'h1234;

        @(posedge clk);

        #1;


        check_outputs(1, 6'h20, 0, 0, 16'h1234);
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
        input expected_atb_read;
        input [5:0] expected_atb_register;
        input expected_atb_write;
        input [15:0] expected_atb_writedata;
        input [15:0] expected_slave_readdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_atb_read === (expected_atb_read ^ atb_read ^ expected_atb_read) &&
                expected_atb_register === (expected_atb_register ^ atb_register ^ expected_atb_register) &&
                expected_atb_write === (expected_atb_write ^ atb_write ^ expected_atb_write) &&
                expected_atb_writedata === (expected_atb_writedata ^ atb_writedata ^ expected_atb_writedata) &&
                expected_slave_readdata === (expected_slave_readdata ^ slave_readdata ^ expected_slave_readdata)) begin
                $display("PASS");
                $display("  Outputs: atb_read=%b, atb_register=%h, atb_write=%b, atb_writedata=%h, slave_readdata=%h",
                         atb_read, atb_register, atb_write, atb_writedata, slave_readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: atb_read=%b, atb_register=%h, atb_write=%b, atb_writedata=%h, slave_readdata=%h",
                         expected_atb_read, expected_atb_register, expected_atb_write, expected_atb_writedata, expected_slave_readdata);
                $display("  Got:      atb_read=%b, atb_register=%h, atb_write=%b, atb_writedata=%h, slave_readdata=%h",
                         atb_read, atb_register, atb_write, atb_writedata, slave_readdata);
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

endmodule
