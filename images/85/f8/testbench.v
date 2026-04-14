`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg [15:0] in_port;
    reg reset_n;
    reg write_n;
    reg [15:0] writedata;
    wire [15:0] out_port;
    wire [15:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .in_port(in_port),
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
        in_port = 0;
        write_n = 1;
        writedata = 0;
        repeat(2) @(posedge clk);
        #1 reset_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Power-on Reset", test_num);
        reset_dut();




        #1;





        check_outputs(16'h0000, readdata);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Basic Write to Out Port", test_num);
        reset_dut();

        @(posedge clk);
        address = 2'b00;
        chipselect = 1;
        write_n = 0;
        writedata = 16'hABCD;

        @(posedge clk);
        #1;
        chipselect = 0;
        write_n = 1;


        #1;



        check_outputs(16'hABCD, readdata);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Basic Read from In Port", test_num);
        reset_dut();

        @(posedge clk);
        in_port = 16'h1234;
        address = 2'b00;
        chipselect = 1;
        write_n = 1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, 16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Chipselect Isolation Test", test_num);
        reset_dut();


        @(posedge clk);
        address = 2'b00;
        chipselect = 0;
        write_n = 0;
        writedata = 16'hFFFF;

        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, readdata);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Write-Enable (write_n) Check", test_num);
        reset_dut();


        @(posedge clk);
        address = 2'b00;
        chipselect = 1;
        write_n = 1;
        writedata = 16'h5555;

        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, readdata);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Multiple Operations Sequence", test_num);
        reset_dut();


        @(posedge clk);
        address = 2'b00;
        chipselect = 1;
        write_n = 0;
        writedata = 16'hAAAA;
        @(posedge clk);


        #1;
        write_n = 1;
        in_port = 16'hBBBB;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'hAAAA, 16'hBBBB);
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
        input [15:0] expected_out_port;
        input [15:0] expected_readdata;
        begin
            if (expected_out_port === (expected_out_port ^ out_port ^ expected_out_port) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: out_port=%h, readdata=%h",
                         out_port, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_port=%h, readdata=%h",
                         expected_out_port, expected_readdata);
                $display("  Got:      out_port=%h, readdata=%h",
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
        $dumpvars(0,address, chipselect, clk, in_port, reset_n, write_n, writedata, out_port, readdata);
    end

endmodule
