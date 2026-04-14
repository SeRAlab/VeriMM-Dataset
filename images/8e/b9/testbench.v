`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg clock;
    reg [31:0] data_in;
    reg reset_n;
    reg write_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data_in(data_in),
        .reset_n(reset_n),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset_n = 0;
        address = 0;
        data_in = 0;
        write_en = 0;
        @(posedge clock);
        #2;
        reset_n = 1;
        @(posedge clock);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_n = 0;
        address = 5'h1F;
        data_in = 32'hFFFFFFFF;
        write_en = 1;
        repeat(2) @(posedge clock);
        #2;

        #1;


        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        @(posedge clock);
        write_en = 1;
        address = 5'h00;
        data_in = 32'hDEADBEEF;
        @(posedge clock);
        #2;

        write_en = 0;
        address = 5'h00;
        @(posedge clock);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        @(posedge clock);
        write_en = 1;
        address = 5'd31;
        data_in = 32'h12345678;
        @(posedge clock);
        #2;

        write_en = 0;
        address = 5'd31;
        @(posedge clock);
        #2;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(posedge clock);
        write_en = 1;
        address = 5'h0A;
        data_in = 32'hAAAA_AAAA;
        @(posedge clock);
        #2;

        write_en = 1;
        address = 5'h0A;
        data_in = 32'hBBBB_BBBB;
        @(posedge clock);
        #2;

        write_en = 0;
        address = 5'h0A;
        @(posedge clock);
        #2;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        @(posedge clock);
        write_en = 1;
        address = 5'h01;
        data_in = 32'h1111_1111;
        @(posedge clock);
        #2;

        write_en = 1;
        address = 5'h02;
        data_in = 32'h2222_2222;
        @(posedge clock);
        #2;

        write_en = 0;
        address = 5'h01;
        @(posedge clock);
        #2;
        #1;

        check_outputs(32'h1111_1111);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, clock, data_in, reset_n, write_en, data_out);
    end

endmodule
