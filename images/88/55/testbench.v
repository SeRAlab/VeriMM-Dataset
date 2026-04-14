`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] address_0;
    reg [31:0] address_1;
    reg command_0;
    reg command_1;
    reg enable_0;
    reg enable_1;
    reg [31:0] read_data;
    reg select;
    reg valid;
    reg [31:0] write_data_0;
    reg [31:0] write_data_1;
    reg [3:0] write_mask_0;
    reg [3:0] write_mask_1;
    wire [31:0] address;
    wire command;
    wire enable;
    wire [31:0] read_data_0;
    wire [31:0] read_data_1;
    wire valid_0;
    wire valid_1;
    wire [31:0] write_data;
    wire [3:0] write_mask;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_0(address_0),
        .address_1(address_1),
        .command_0(command_0),
        .command_1(command_1),
        .enable_0(enable_0),
        .enable_1(enable_1),
        .read_data(read_data),
        .select(select),
        .valid(valid),
        .write_data_0(write_data_0),
        .write_data_1(write_data_1),
        .write_mask_0(write_mask_0),
        .write_mask_1(write_mask_1),
        .address(address),
        .command(command),
        .enable(enable),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1),
        .valid_0(valid_0),
        .valid_1(valid_1),
        .write_data(write_data),
        .write_mask(write_mask)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select Channel 0 - Basic Write Operation");

            select = 0;
            enable_0 = 1;
            command_0 = 1;
            address_0 = 32'hAAAA_BBBB;
            write_data_0 = 32'h1234_5678;
            write_mask_0 = 4'hF;

            enable_1 = 0;
            command_1 = 0;
            address_1 = 32'hCCCC_DDDD;
            write_data_1 = 32'h0000_0000;
            write_mask_1 = 4'h0;

            read_data = 32'h0;
            valid = 0;



            #1;




            check_outputs(32'hAAAA_BBBB, 1, 1, 32'h0, 32'h0, 0, 0, 32'h1234_5678, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select Channel 1 - Basic Read Operation");

            select = 1;
            enable_1 = 1;
            command_1 = 0;
            address_1 = 32'h5555_6666;
            write_data_1 = 32'h0;
            write_mask_1 = 4'h0;

            enable_0 = 0;
            command_0 = 1;
            address_0 = 32'hEEEE_FFFF;

            read_data = 32'hCAFE_BABE;
            valid = 1;



            #1;




            check_outputs(32'h5555_6666, 0, 1, 32'h0, 32'hCAFE_BABE, 0, 1, 32'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Channel 0 - Verify Data Isolation");
            select = 0;
            enable_0 = 1;
            command_0 = 0;
            address_0 = 32'h1111_1111;
            write_data_0 = 32'hFFFF_FFFF;
            write_mask_0 = 4'hA;

            read_data = 32'h8888_9999;
            valid = 1;


            enable_1 = 1;
            command_1 = 1;
            address_1 = 32'h2222_2222;

            #1;


            check_outputs(32'h1111_1111, 0, 1, 32'h8888_9999, 32'h0, 1, 0, 32'hFFFF_FFFF, 4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Channel 1 - Verify Masking and Data");
            select = 1;
            enable_1 = 1;
            command_1 = 1;
            address_1 = 32'hDEAD_BEEF;
            write_data_1 = 32'h55AA_55AA;
            write_mask_1 = 4'h3;


            read_data = 32'h0;
            valid = 0;

            #1;


            check_outputs(32'hDEAD_BEEF, 1, 1, 32'h0, 32'h0, 0, 0, 32'h55AA_55AA, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Switch Select Dynamically");

            select = 0;
            address_0 = 32'h0; address_1 = 32'hFFFF_FFFF;
            enable_0 = 1; enable_1 = 0;
            #5;

            select = 1;
            enable_0 = 0; enable_1 = 1;
            command_1 = 1;
            write_data_1 = 32'h1234_1234;
            write_mask_1 = 4'hF;
            read_data = 32'h0;
            valid = 0;

            #1;


            check_outputs(32'hFFFF_FFFF, 1, 1, 32'h0, 32'h0, 0, 0, 32'h1234_1234, 4'hF);
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
        input [31:0] expected_address;
        input expected_command;
        input expected_enable;
        input [31:0] expected_read_data_0;
        input [31:0] expected_read_data_1;
        input expected_valid_0;
        input expected_valid_1;
        input [31:0] expected_write_data;
        input [3:0] expected_write_mask;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_command === (expected_command ^ command ^ expected_command) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_read_data_0 === (expected_read_data_0 ^ read_data_0 ^ expected_read_data_0) &&
                expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1) &&
                expected_valid_0 === (expected_valid_0 ^ valid_0 ^ expected_valid_0) &&
                expected_valid_1 === (expected_valid_1 ^ valid_1 ^ expected_valid_1) &&
                expected_write_data === (expected_write_data ^ write_data ^ expected_write_data) &&
                expected_write_mask === (expected_write_mask ^ write_mask ^ expected_write_mask)) begin
                $display("PASS");
                $display("  Outputs: address=%h, command=%b, enable=%b, read_data_0=%h, read_data_1=%h, valid_0=%b, valid_1=%b, write_data=%h, write_mask=%h",
                         address, command, enable, read_data_0, read_data_1, valid_0, valid_1, write_data, write_mask);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, command=%b, enable=%b, read_data_0=%h, read_data_1=%h, valid_0=%b, valid_1=%b, write_data=%h, write_mask=%h",
                         expected_address, expected_command, expected_enable, expected_read_data_0, expected_read_data_1, expected_valid_0, expected_valid_1, expected_write_data, expected_write_mask);
                $display("  Got:      address=%h, command=%b, enable=%b, read_data_0=%h, read_data_1=%h, valid_0=%b, valid_1=%b, write_data=%h, write_mask=%h",
                         address, command, enable, read_data_0, read_data_1, valid_0, valid_1, write_data, write_mask);
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
