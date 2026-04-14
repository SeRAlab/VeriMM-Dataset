`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [3:0] attr;
    reg clk;
    reg write;
    reg [7:0] write_data;
    wire [7:0] index;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .attr(attr),
        .clk(clk),
        .write(write),
        .write_data(write_data),
        .index(index),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        address = 4'd0;
        attr = 4'd0;
        write = 0;
        write_data = 8'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Basic Write and Dual Readback", test_num);


        address = 4'h3;
        write_data = 8'hA5;
        write = 1;
        @(posedge clk);
        #1;
        write = 0;


        address = 4'h3;
        attr = 4'h3;
        #2;
        #1;

        check_outputs(8'hA5, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Independent Port Access", test_num);


        address = 4'h5; write_data = 8'h55; write = 1; @(posedge clk); #1;
        address = 4'hA; write_data = 8'hAA; write = 1; @(posedge clk); #1;
        write = 0;


        address = 4'h5;
        attr = 4'hA;
        #2;
        #1;

        check_outputs(8'hAA, 8'h55);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Write Enable Logic", test_num);


        address = 4'h7; write_data = 8'h77; write = 1; @(posedge clk); #1;


        write = 0;
        write_data = 8'h99;
        @(posedge clk);
        #1;


        address = 4'h7;
        attr = 4'h7;
        #2;
        #1;

        check_outputs(8'h77, 8'h77);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Boundary Addresses", test_num);


        address = 4'h0; write_data = 8'h01; write = 1; @(posedge clk); #1;

        address = 4'hF; write_data = 8'hFE; write = 1; @(posedge clk); #1;
        write = 0;

        address = 4'h0;
        attr = 4'hF;
        #2;
        #1;

        check_outputs(8'hFE, 8'h01);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Value Overwrite", test_num);

        address = 4'h2; write_data = 8'h11; write = 1; @(posedge clk); #1;
        address = 4'h2; write_data = 8'h22; write = 1; @(posedge clk); #1;
        write = 0;

        address = 4'h2;
        attr = 4'h2;
        #2;
        #1;

        check_outputs(8'h22, 8'h22);
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
        input [7:0] expected_index;
        input [7:0] expected_read_data;
        begin
            if (expected_index === (expected_index ^ index ^ expected_index) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: index=%h, read_data=%h",
                         index, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: index=%h, read_data=%h",
                         expected_index, expected_read_data);
                $display("  Got:      index=%h, read_data=%h",
                         index, read_data);
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
        $dumpvars(0,address, attr, clk, write, write_data, index, read_data);
    end

endmodule
