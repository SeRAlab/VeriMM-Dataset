`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] address;
    reg burstbegin;
    reg burstcount;
    reg [3:0] byteenable;
    reg clk;
    reg export_interrupt;
    reg [31:0] export_readdata;
    reg export_readdatavalid;
    reg export_waitrequest;
    reg read;
    reg reset;
    reg write;
    reg [31:0] writedata;
    wire [31:0] export_address;
    wire export_burstbegin;
    wire export_burstcount;
    wire [3:0] export_byteenable;
    wire export_read;
    wire export_write;
    wire [31:0] export_writedata;
    wire interrupt;
    wire [31:0] readdata;
    wire readdatavalid;
    wire waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .burstbegin(burstbegin),
        .burstcount(burstcount),
        .byteenable(byteenable),
        .clk(clk),
        .export_interrupt(export_interrupt),
        .export_readdata(export_readdata),
        .export_readdatavalid(export_readdatavalid),
        .export_waitrequest(export_waitrequest),
        .read(read),
        .reset(reset),
        .write(write),
        .writedata(writedata),
        .export_address(export_address),
        .export_burstbegin(export_burstbegin),
        .export_burstcount(export_burstcount),
        .export_byteenable(export_byteenable),
        .export_read(export_read),
        .export_write(export_write),
        .export_writedata(export_writedata),
        .interrupt(interrupt),
        .readdata(readdata),
        .readdatavalid(readdatavalid),
        .waitrequest(waitrequest)
    );
    task testcase001;

    begin
        $display("Test Case 001: Reset Behavior");
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Single Write Operation");
        reset_dut();
        address = 32'h12345678;
        writedata = 32'hDEADBEEF;
        write = 1;
        byteenable = 4'b1111;
        burstbegin = 1;
        burstcount = 1;
        @(posedge clk);
        #1;

        check_outputs(32'h12345678, 1'b1, 1'b1, 4'hF, 1'b0, 1'b1, 32'hDEADBEEF, 1'b0, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Single Read Request");
        reset_dut();
        address = 32'h87654321;
        read = 1;
        byteenable = 4'b1111;
        burstbegin = 1;
        burstcount = 1;
        @(posedge clk);
        #1;

        check_outputs(32'h87654321, 1'b1, 1'b1, 4'hF, 1'b1, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Slave Read Data Return");
        reset_dut();
        export_readdata = 32'hCAFEBABE;
        export_readdatavalid = 1;
        @(posedge clk);
        #1;

        check_outputs(32'h0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'hCAFEBABE, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Slave Wait Request Signal");
        reset_dut();
        export_waitrequest = 1;
        address = 32'hA0A0A0A0;
        write = 1;
        @(posedge clk);
        #1;

        check_outputs(32'hA0A0A0A0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b1, 32'h0, 1'b0, 32'h0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: External Interrupt Propagation");
        reset_dut();
        export_interrupt = 1;
        @(posedge clk);
        #1;

        check_outputs(32'h0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 32'h0, 1'b1, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Byte Enable Alignment Check");
        reset_dut();
        address = 32'h00000003;
        byteenable = 4'b1000;
        write = 1;
        writedata = 32'hFF000000;
        @(posedge clk);
        #1;

        check_outputs(32'h00000003, 1'b0, 1'b0, 4'h8, 1'b0, 1'b1, 32'hFF000000, 1'b0, 32'h0, 1'b0, 1'b0);
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
        testcase007();
        
        
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
        input [31:0] expected_export_address;
        input expected_export_burstbegin;
        input expected_export_burstcount;
        input [3:0] expected_export_byteenable;
        input expected_export_read;
        input expected_export_write;
        input [31:0] expected_export_writedata;
        input expected_interrupt;
        input [31:0] expected_readdata;
        input expected_readdatavalid;
        input expected_waitrequest;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_export_address === (expected_export_address ^ export_address ^ expected_export_address) &&
                expected_export_burstbegin === (expected_export_burstbegin ^ export_burstbegin ^ expected_export_burstbegin) &&
                expected_export_burstcount === (expected_export_burstcount ^ export_burstcount ^ expected_export_burstcount) &&
                expected_export_byteenable === (expected_export_byteenable ^ export_byteenable ^ expected_export_byteenable) &&
                expected_export_read === (expected_export_read ^ export_read ^ expected_export_read) &&
                expected_export_write === (expected_export_write ^ export_write ^ expected_export_write) &&
                expected_export_writedata === (expected_export_writedata ^ export_writedata ^ expected_export_writedata) &&
                expected_interrupt === (expected_interrupt ^ interrupt ^ expected_interrupt) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata) &&
                expected_readdatavalid === (expected_readdatavalid ^ readdatavalid ^ expected_readdatavalid) &&
                expected_waitrequest === (expected_waitrequest ^ waitrequest ^ expected_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: export_address=%h, export_burstbegin=%b, export_burstcount=%b, export_byteenable=%h, export_read=%b, export_write=%b, export_writedata=%h, interrupt=%b, readdata=%h, readdatavalid=%b, waitrequest=%b",
                         export_address, export_burstbegin, export_burstcount, export_byteenable, export_read, export_write, export_writedata, interrupt, readdata, readdatavalid, waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: export_address=%h, export_burstbegin=%b, export_burstcount=%b, export_byteenable=%h, export_read=%b, export_write=%b, export_writedata=%h, interrupt=%b, readdata=%h, readdatavalid=%b, waitrequest=%b",
                         expected_export_address, expected_export_burstbegin, expected_export_burstcount, expected_export_byteenable, expected_export_read, expected_export_write, expected_export_writedata, expected_interrupt, expected_readdata, expected_readdatavalid, expected_waitrequest);
                $display("  Got:      export_address=%h, export_burstbegin=%b, export_burstcount=%b, export_byteenable=%h, export_read=%b, export_write=%b, export_writedata=%h, interrupt=%b, readdata=%h, readdatavalid=%b, waitrequest=%b",
                         export_address, export_burstbegin, export_burstcount, export_byteenable, export_read, export_write, export_writedata, interrupt, readdata, readdatavalid, waitrequest);
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
