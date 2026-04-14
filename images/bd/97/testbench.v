`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk50;
    reg [21:0] ramAddr_i;
    reg [31:0] ramData_i;
    reg [2:0] ramOp_i;
    reg rst;
    reg [31:0] storeData_i;
    wire busEnable_o;
    wire [21:0] ramAddr_o;
    wire [31:0] ramData_o;
    wire readEnable_o;
    wire sramEnable_o;
    wire [31:0] writeData_o;
    wire writeEnable_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk50(clk50),
        .ramAddr_i(ramAddr_i),
        .ramData_i(ramData_i),
        .ramOp_i(ramOp_i),
        .rst(rst),
        .storeData_i(storeData_i),
        .busEnable_o(busEnable_o),
        .ramAddr_o(ramAddr_o),
        .ramData_o(ramData_o),
        .readEnable_o(readEnable_o),
        .sramEnable_o(sramEnable_o),
        .writeData_o(writeData_o),
        .writeEnable_o(writeEnable_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk50 = 0;
        forever #5 clk50 = ~clk50;
    end

        task reset_dut;

        begin
            rst = 1;
            ramAddr_i = 22'h0;
            ramData_i = 32'h0;
            ramOp_i = 3'b000;
            storeData_i = 32'h0;
            @(posedge clk50);
            #2;
            rst = 0;
            @(posedge clk50);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle State", test_num);
            reset_dut();

            ramOp_i = 3'b000;
            ramAddr_i = 22'h100;

            repeat(2) @(posedge clk50);
            #2;

            #1;


            check_outputs(0, 22'h100, 32'h0, 0, 0, 32'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Word Operation", test_num);
            reset_dut();


            ramOp_i = 3'b010;
            ramAddr_i = 22'h000ABC;
            storeData_i = 32'hDEADBEEF;

            repeat(2) @(posedge clk50);
            #2;

            #1;


            check_outputs(1, 22'h000ABC, 32'h0, 0, 1, 32'hDEADBEEF, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Read Word Operation", test_num);
            reset_dut();


            ramOp_i = 3'b001;
            ramAddr_i = 22'h000123;
            ramData_i = 32'hCAFEBABE;

            repeat(2) @(posedge clk50);
            #2;

            #1;


            check_outputs(1, 22'h000123, 32'hCAFEBABE, 1, 1, 32'h0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Max Address Write", test_num);
            reset_dut();

            ramOp_i = 3'b010;
            ramAddr_i = 22'h3FFFFF;
            storeData_i = 32'h12345678;

            repeat(2) @(posedge clk50);
            #2;
            #1;

            check_outputs(1, 22'h3FFFFF, 32'h0, 0, 1, 32'h12345678, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transition Write to Read", test_num);
            reset_dut();


            ramOp_i = 3'b010;
            ramAddr_i = 22'h55;
            storeData_i = 32'hAAAA_5555;
            @(posedge clk50);


            ramOp_i = 3'b001;
            ramAddr_i = 22'h66;
            ramData_i = 32'hBBBB_6666;

            repeat(2) @(posedge clk50);
            #2;

            #1;


            check_outputs(1, 22'h66, 32'hBBBB_6666, 1, 1, 32'h0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset During Operation", test_num);
            reset_dut();

            ramOp_i = 3'b010;
            ramAddr_i = 22'h77;
            storeData_i = 32'hFFFFFFFF;

            @(posedge clk50);
            rst = 1;
            @(posedge clk50);
            #2;



            #1;




            check_outputs(0, 22'h0, 32'h0, 0, 0, 32'h0, 0);
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
        input expected_busEnable_o;
        input [21:0] expected_ramAddr_o;
        input [31:0] expected_ramData_o;
        input expected_readEnable_o;
        input expected_sramEnable_o;
        input [31:0] expected_writeData_o;
        input expected_writeEnable_o;
        begin
            if (expected_busEnable_o === (expected_busEnable_o ^ busEnable_o ^ expected_busEnable_o) &&
                expected_ramAddr_o === (expected_ramAddr_o ^ ramAddr_o ^ expected_ramAddr_o) &&
                expected_ramData_o === (expected_ramData_o ^ ramData_o ^ expected_ramData_o) &&
                expected_readEnable_o === (expected_readEnable_o ^ readEnable_o ^ expected_readEnable_o) &&
                expected_sramEnable_o === (expected_sramEnable_o ^ sramEnable_o ^ expected_sramEnable_o) &&
                expected_writeData_o === (expected_writeData_o ^ writeData_o ^ expected_writeData_o) &&
                expected_writeEnable_o === (expected_writeEnable_o ^ writeEnable_o ^ expected_writeEnable_o)) begin
                $display("PASS");
                $display("  Outputs: busEnable_o=%b, ramAddr_o=%h, ramData_o=%h, readEnable_o=%b, sramEnable_o=%b, writeData_o=%h, writeEnable_o=%b",
                         busEnable_o, ramAddr_o, ramData_o, readEnable_o, sramEnable_o, writeData_o, writeEnable_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busEnable_o=%b, ramAddr_o=%h, ramData_o=%h, readEnable_o=%b, sramEnable_o=%b, writeData_o=%h, writeEnable_o=%b",
                         expected_busEnable_o, expected_ramAddr_o, expected_ramData_o, expected_readEnable_o, expected_sramEnable_o, expected_writeData_o, expected_writeEnable_o);
                $display("  Got:      busEnable_o=%b, ramAddr_o=%h, ramData_o=%h, readEnable_o=%b, sramEnable_o=%b, writeData_o=%h, writeEnable_o=%b",
                         busEnable_o, ramAddr_o, ramData_o, readEnable_o, sramEnable_o, writeData_o, writeEnable_o);
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
        $dumpvars(0,clk50, ramAddr_i, ramData_i, ramOp_i, rst, storeData_i, busEnable_o, ramAddr_o, ramData_o, readEnable_o, sramEnable_o, writeData_o, writeEnable_o);
    end

endmodule
