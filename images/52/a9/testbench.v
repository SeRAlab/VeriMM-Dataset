`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg reset_n;
    reg write_n;
    reg writedata;
    wire out_port;
    wire readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .reset_n(reset_n),
        .write_n(write_n),
        .writedata(writedata),
        .out_port(out_port),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        address = 0;
        chipselect = 0;
        write_n = 1;
        writedata = 0;
        repeat(2) @(posedge clk);
        #1;
        reset_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        address = 2'b00;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write '1' to Address 0", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b00;
        chipselect = 1;
        write_n = 0;
        writedata = 1;

        @(posedge clk);
        #1;
        write_n = 1;
        chipselect = 0;


        address = 2'b00;
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write '0' to Address 0", test_num);
        reset_dut();


        @(posedge clk);
        address = 2'b00; chipselect = 1; write_n = 0; writedata = 1;
        @(posedge clk);
        #1;

        writedata = 0;
        @(posedge clk);
        #1;
        write_n = 1;

        address = 2'b00;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Write Failure (chipselect=0)", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b00;
        chipselect = 0;
        write_n = 0;
        writedata = 1;

        @(posedge clk);
        #1;
        address = 2'b00;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Write Failure (write_n=1)", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b00;
        chipselect = 1;
        write_n = 1;
        writedata = 1;

        @(posedge clk);
        #1;
        address = 2'b00;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Write Failure (address=1)", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b01;
        chipselect = 1;
        write_n = 0;
        writedata = 1;

        @(posedge clk);
        #1;
        address = 2'b00;
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_out_port;
        input expected_readdata;
        begin
            if (expected_out_port === (expected_out_port ^ out_port ^ expected_out_port) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: out_port=%b, readdata=%b",
                         out_port, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_port=%b, readdata=%b",
                         expected_out_port, expected_readdata);
                $display("  Got:      out_port=%b, readdata=%b",
                         out_port, readdata);
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
        $dumpvars(0,address, chipselect, clk, reset_n, write_n, writedata, out_port, readdata);
    end

endmodule
