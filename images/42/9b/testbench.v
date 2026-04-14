`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg clk;
    reg [7:0] inData;
    reg rst;
    reg writeEn;
    wire [7:0] outData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .inData(inData),
        .rst(rst),
        .writeEn(writeEn),
        .outData(outData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            writeEn = 0;
            address = 0;
            inData = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task write_reg;

        input [1:0] addr;
        input [8:0] data;
        begin
            @(posedge clk);
            address = addr;
            inData = data;
            writeEn = 1;
            @(posedge clk);
            #1;
            writeEn = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial Reset State", test_num);
            reset_dut();
            address = 2'b10;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Single Write/Read (Addr 1)", test_num);
            reset_dut();
            @(posedge clk);
            address = 2'b01;
            inData = 8'hA5;
            writeEn = 1;
            @(posedge clk);
            #1;
            writeEn = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Multiple Writes Persistence", test_num);
            reset_dut();

            write_reg(2'b00, 8'h11);
            write_reg(2'b01, 8'h22);
            write_reg(2'b10, 8'h33);
            write_reg(2'b11, 8'h44);


            address = 2'b10;
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Write Enable Low (No Change)", test_num);
            reset_dut();

            write_reg(2'b00, 8'h55);

            @(posedge clk);
            address = 2'b00;
            inData = 8'hFF;
            writeEn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Overwrite Register", test_num);
            reset_dut();
            write_reg(2'b11, 8'hAA);
            write_reg(2'b11, 8'h55);
            address = 2'b11;
            #1;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_outData;
        begin
            if (expected_outData === (expected_outData ^ outData ^ expected_outData)) begin
                $display("PASS");
                $display("  Outputs: outData=%h",
                         outData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outData=%h",
                         expected_outData);
                $display("  Got:      outData=%h",
                         outData);
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
        $dumpvars(0,address, clk, inData, rst, writeEn, outData);
    end

endmodule
