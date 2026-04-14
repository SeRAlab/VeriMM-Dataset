`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr_port1;
    reg [15:0] addr_port2;
    reg [15:0] data_in_port1;
    reg [15:0] data_in_port2;
    reg write_en_port1;
    reg write_en_port2;
    wire [15:0] data_out_port1;
    wire [15:0] data_out_port2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_port1(addr_port1),
        .addr_port2(addr_port2),
        .data_in_port1(data_in_port1),
        .data_in_port2(data_in_port2),
        .write_en_port1(write_en_port1),
        .write_en_port2(write_en_port2),
        .data_out_port1(data_out_port1),
        .data_out_port2(data_out_port2)
    );

    // Clock generation (10ns period)
    initial begin
        write_en_port1 = 0;
        forever #5 write_en_port1 = ~write_en_port1;
    end

        task reset_dut;

    begin
        addr_port1 = 16'h0000;
        addr_port2 = 16'h0000;
        data_in_port1 = 16'h0000;
        data_in_port2 = 16'h0000;
        write_en_port2 = 1;

        @(posedge write_en_port1);
        #2;

        write_en_port2 = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Port 1 Basic Write and Read");
        reset_dut();
        test_num = 1;
        addr_port1 = 16'h0001;
        data_in_port1 = 16'hAAAA;

        @(posedge write_en_port1);
        #2;

        #1;


        check_outputs(16'hAAAA, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Port 2 Basic Write and Read");
        reset_dut();
        test_num = 2;
        addr_port2 = 16'h0002;
        data_in_port2 = 16'hBBBB;

        write_en_port2 = 0; #2;
        write_en_port2 = 1; #5;
        write_en_port2 = 0; #2;

        #1;


        check_outputs(16'h0000, 16'hBBBB);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Simultaneous Write to Different Addresses");
        reset_dut();
        test_num = 3;

        addr_port1 = 16'h000A;
        data_in_port1 = 16'h1111;

        addr_port2 = 16'h000B;
        data_in_port2 = 16'h2222;
        write_en_port2 = 1;

        @(posedge write_en_port1);
        #2;
        write_en_port2 = 0;
        #5;
        #1;

        check_outputs(16'h1111, 16'h2222);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Port 1 Write, Port 2 Read (Same Address)");
        reset_dut();
        test_num = 4;

        addr_port1 = 16'h0055;
        data_in_port1 = 16'h5555;
        @(posedge write_en_port1);
        #2;

        addr_port2 = 16'h0055;
        #5;
        #1;

        check_outputs(16'h5555, 16'h5555);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Port 2 Write, Port 1 Read (Same Address)");
        reset_dut();
        test_num = 5;

        addr_port2 = 16'h0066;
        data_in_port2 = 16'h6666;
        write_en_port2 = 0; #2;
        write_en_port2 = 1; #5;
        write_en_port2 = 0; #2;


        addr_port1 = 16'h0066;
        data_in_port1 = 16'h6666;
        #5;
        #1;

        check_outputs(16'h6666, 16'h6666);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Simultaneous Read from Same Address");
        reset_dut();
        test_num = 6;

        addr_port1 = 16'h0099;
        data_in_port1 = 16'h9999;
        @(posedge write_en_port1);
        #2;

        addr_port1 = 16'h0099;
        addr_port2 = 16'h0099;
        data_in_port1 = 16'h9999;
        #5;
        #1;

        check_outputs(16'h9999, 16'h9999);
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
        input [15:0] expected_data_out_port1;
        input [15:0] expected_data_out_port2;
        begin
            if (expected_data_out_port1 === (expected_data_out_port1 ^ data_out_port1 ^ expected_data_out_port1) &&
                expected_data_out_port2 === (expected_data_out_port2 ^ data_out_port2 ^ expected_data_out_port2)) begin
                $display("PASS");
                $display("  Outputs: data_out_port1=%h, data_out_port2=%h",
                         data_out_port1, data_out_port2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_port1=%h, data_out_port2=%h",
                         expected_data_out_port1, expected_data_out_port2);
                $display("  Got:      data_out_port1=%h, data_out_port2=%h",
                         data_out_port1, data_out_port2);
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
        $dumpvars(0,addr_port1, addr_port2, data_in_port1, data_in_port2, write_en_port1, write_en_port2, data_out_port1, data_out_port2);
    end

endmodule
