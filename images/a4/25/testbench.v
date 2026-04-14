`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] i2c_hs_readdata;
    reg reset;
    reg [2:0] slave_address;
    reg slave_read;
    reg slave_write;
    reg [31:0] slave_writedata;
    wire [2:0] i2c_hs_addr;
    wire i2c_hs_read;
    wire i2c_hs_write;
    wire [31:0] i2c_hs_writedata;
    wire [31:0] slave_readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i2c_hs_readdata(i2c_hs_readdata),
        .reset(reset),
        .slave_address(slave_address),
        .slave_read(slave_read),
        .slave_write(slave_write),
        .slave_writedata(slave_writedata),
        .i2c_hs_addr(i2c_hs_addr),
        .i2c_hs_read(i2c_hs_read),
        .i2c_hs_write(i2c_hs_write),
        .i2c_hs_writedata(i2c_hs_writedata),
        .slave_readdata(slave_readdata)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset and Idle Check", test_num);

        reset = 1;
        slave_read = 0;
        slave_write = 0;
        slave_address = 0;
        slave_writedata = 0;
        i2c_hs_readdata = 32'h0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b000, 1'b0, 1'b0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write Operation", test_num);

        reset = 1; @(posedge clk); #1; reset = 0;

        slave_write = 1;
        slave_address = 3'h2;
        slave_writedata = 32'hDEADBEEF;
        @(posedge clk);

        #1;


        check_outputs(3'h2, 1'b0, 1'b1, 32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Read Operation", test_num);

        reset = 1; @(posedge clk); #1; reset = 0;

        slave_read = 1;
        slave_address = 3'h5;
        i2c_hs_readdata = 32'hCAFEBABE;
        @(posedge clk);

        #1;


        check_outputs(3'h5, 1'b1, 1'b0, 32'h0, 32'hCAFEBABE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address Write", test_num);

        reset = 1; @(posedge clk); #1; reset = 0;

        slave_write = 1;
        slave_address = 3'h7;
        slave_writedata = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        check_outputs(3'h7, 1'b0, 1'b1, 32'hFFFFFFFF, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read from Address 0", test_num);

        reset = 1; @(posedge clk); #1; reset = 0;

        slave_read = 1;
        slave_address = 3'h0;
        i2c_hs_readdata = 32'h55AA55AA;
        @(posedge clk);
        #1;

        check_outputs(3'h0, 1'b1, 1'b0, 32'h0, 32'h55AA55AA);
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
        input [2:0] expected_i2c_hs_addr;
        input expected_i2c_hs_read;
        input expected_i2c_hs_write;
        input [31:0] expected_i2c_hs_writedata;
        input [31:0] expected_slave_readdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i2c_hs_addr === (expected_i2c_hs_addr ^ i2c_hs_addr ^ expected_i2c_hs_addr) &&
                expected_i2c_hs_read === (expected_i2c_hs_read ^ i2c_hs_read ^ expected_i2c_hs_read) &&
                expected_i2c_hs_write === (expected_i2c_hs_write ^ i2c_hs_write ^ expected_i2c_hs_write) &&
                expected_i2c_hs_writedata === (expected_i2c_hs_writedata ^ i2c_hs_writedata ^ expected_i2c_hs_writedata) &&
                expected_slave_readdata === (expected_slave_readdata ^ slave_readdata ^ expected_slave_readdata)) begin
                $display("PASS");
                $display("  Outputs: i2c_hs_addr=%h, i2c_hs_read=%b, i2c_hs_write=%b, i2c_hs_writedata=%h, slave_readdata=%h",
                         i2c_hs_addr, i2c_hs_read, i2c_hs_write, i2c_hs_writedata, slave_readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i2c_hs_addr=%h, i2c_hs_read=%b, i2c_hs_write=%b, i2c_hs_writedata=%h, slave_readdata=%h",
                         expected_i2c_hs_addr, expected_i2c_hs_read, expected_i2c_hs_write, expected_i2c_hs_writedata, expected_slave_readdata);
                $display("  Got:      i2c_hs_addr=%h, i2c_hs_read=%b, i2c_hs_write=%b, i2c_hs_writedata=%h, slave_readdata=%h",
                         i2c_hs_addr, i2c_hs_read, i2c_hs_write, i2c_hs_writedata, slave_readdata);
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
