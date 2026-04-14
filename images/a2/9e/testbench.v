`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [1:0] read_address;
    reg reset_n;
    reg [1:0] write_address;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .read_address(read_address),
        .reset_n(reset_n),
        .write_address(write_address),
        .write_data(write_data),
        .write_en(write_en),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset_n = 0;
        write_en = 0;
        write_address = 0;
        write_data = 0;
        read_address = 0;
        #15;
        reset_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Power-on Reset Check", test_num);
        reset_dut();
        read_address = 2'b10;
        #5;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Write and Read back from Reg 0", test_num);
        reset_dut();
        @(posedge clock);
        write_en = 1;
        write_address = 2'b00;
        write_data = 8'hA5;
        @(posedge clock);
        write_en = 0;
        read_address = 2'b00;
        #5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Write and Read back from Reg 3", test_num);
        reset_dut();
        @(posedge clock);
        write_en = 1;
        write_address = 2'b11;
        write_data = 8'h5A;
        @(posedge clock);
        write_en = 0;
        read_address = 2'b11;
        #5;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Verify Write Enable (No write when low)", test_num);
        reset_dut();
        @(posedge clock);
        write_en = 0;
        write_address = 2'b01;
        write_data = 8'hFF;
        @(posedge clock);
        read_address = 2'b01;
        #5;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Overwrite Reg 2", test_num);
        reset_dut();
        @(posedge clock);
        write_en = 1;
        write_address = 2'b10;
        write_data = 8'h11;
        @(posedge clock);
        write_data = 8'h22;
        @(posedge clock);
        write_en = 0;
        read_address = 2'b10;
        #5;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Multi-register retention check", test_num);
        reset_dut();

        @(posedge clock);
        write_en = 1; write_address = 2'b00; write_data = 8'h01;

        @(posedge clock);
        write_en = 1; write_address = 2'b01; write_data = 8'h02;

        @(posedge clock);
        write_en = 1; write_address = 2'b10; write_data = 8'h03;

        @(posedge clock);
        write_en = 1; write_address = 2'b11; write_data = 8'h04;
        @(posedge clock);
        write_en = 0;


        read_address = 2'b01;
        #5;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Asynchronous Reset Mid-Operation", test_num);
        reset_dut();
        @(posedge clock);
        write_en = 1;
        write_address = 2'b01;
        write_data = 8'hBC;
        @(posedge clock);
        write_en = 0;
        read_address = 2'b01;
        #2;
        reset_n = 0;
        #2;
        reset_n = 1;
        #5;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clock, read_address, reset_n, write_address, write_data, write_en, read_data);
    end

endmodule
