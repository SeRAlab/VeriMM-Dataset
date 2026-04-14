`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] read_address_1;
    reg [4:0] read_address_2;
    reg reg_write;
    reg rst;
    reg [4:0] write_address;
    reg [31:0] write_data;
    wire [31:0] data_reg_1;
    wire [31:0] data_reg_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .reg_write(reg_write),
        .rst(rst),
        .write_address(write_address),
        .write_data(write_data),
        .data_reg_1(data_reg_1),
        .data_reg_2(data_reg_2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset and Initial State Check");

        rst = 1;
        reg_write = 0;
        write_address = 0;
        write_data = 0;
        read_address_1 = 0;
        read_address_2 = 31;
        #10;
        rst = 0;
        #10;

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single Write and Dual Port Read");

        rst = 1;
        #10;
        rst = 0;
        #10;


        reg_write = 1;
        write_address = 5;
        write_data = 32'hDEADBEEF;
        #10;


        reg_write = 0;
        read_address_1 = 5;
        read_address_2 = 5;
        #10;


        #1;



        check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Dual Port Read of Different Registers");

        rst = 1;
        #10;
        rst = 0;
        #10;


        reg_write = 1;
        write_address = 10;
        write_data = 32'h12345678;
        #10;


        write_address = 20;
        write_data = 32'h87654321;
        #10;


        reg_write = 0;
        read_address_1 = 10;
        read_address_2 = 20;
        #10;


        #1;



        check_outputs(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Write Enable (reg_write) Control Check");

        rst = 1;
        #10;
        rst = 0;
        #10;


        reg_write = 0;
        write_address = 15;
        write_data = 32'hFFFFFFFF;
        #10;


        read_address_1 = 15;
        read_address_2 = 0;
        #10;


        #1;



        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Overwrite and Address Isolation Check");

        rst = 1;
        #10;
        rst = 0;
        #10;


        reg_write = 1;
        write_address = 1;
        write_data = 32'hAAAA_AAAA;
        #10;


        write_address = 2;
        write_data = 32'h5555_5555;
        #10;


        write_address = 1;
        write_data = 32'hCCCC_DDDD;
        #10;


        reg_write = 0;
        read_address_1 = 1;
        read_address_2 = 2;
        #10;


        #1;



        check_outputs(32'hCCCC_DDDD, 32'h5555_5555);
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
        input [31:0] expected_data_reg_1;
        input [31:0] expected_data_reg_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_reg_1 === (expected_data_reg_1 ^ data_reg_1 ^ expected_data_reg_1) &&
                expected_data_reg_2 === (expected_data_reg_2 ^ data_reg_2 ^ expected_data_reg_2)) begin
                $display("PASS");
                $display("  Outputs: data_reg_1=%h, data_reg_2=%h",
                         data_reg_1, data_reg_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_reg_1=%h, data_reg_2=%h",
                         expected_data_reg_1, expected_data_reg_2);
                $display("  Got:      data_reg_1=%h, data_reg_2=%h",
                         data_reg_1, data_reg_2);
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
