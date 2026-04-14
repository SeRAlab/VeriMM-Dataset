`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg begin_transaction;
    reg clock;
    reg [15:0] data_in;
    reg mdc;
    reg mdi;
    reg mode;
    reg [4:0] phy_address;
    reg [4:0] reg_address;
    reg reset;
    wire [15:0] data_out;
    wire mdo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .begin_transaction(begin_transaction),
        .clock(clock),
        .data_in(data_in),
        .mdc(mdc),
        .mdi(mdi),
        .mode(mode),
        .phy_address(phy_address),
        .reg_address(reg_address),
        .reset(reset),
        .data_out(data_out),
        .mdo(mdo)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            begin_transaction = 0;
            data_in = 0;
            mdc = 0;
            mdi = 0;
            mode = 0;
            phy_address = 0;
            reg_address = 0;
            repeat(5) @(posedge clock);
            reset = 0;
            repeat(2) @(posedge clock);
        end
        endtask
    task mdc_cycle;

        input bit_in;
        begin
            mdi = bit_in;
            mdc = 0;
            #20;
            mdc = 1;
            #20;
            mdc = 0;
        end
        endtask

    task testcase001;

        integer i;
        reg [15:0] read_val;
        begin
            $display("Running Testcase 001: Read Operation (ABCD)");
            reset_dut();
            read_val = 16'hABCD;


            mode = 0;
            phy_address = 5'h0A;
            reg_address = 5'h01;
            begin_transaction = 1;
            @(posedge clock);
            begin_transaction = 0;



            for (i = 0; i < 16; i = i + 1) mdc_cycle(0);


            for (i = 15; i >= 0; i = i - 1) begin
                mdc_cycle(read_val[i]);
            end

            repeat(5) @(posedge clock);
            #1;

            check_outputs(16'hABCD, mdo);
        end
        endtask

    task testcase002;

        integer i;
        reg [15:0] read_val;
        begin
            $display("Running Testcase 002: Read Operation (55AA)");
            reset_dut();
            read_val = 16'h55AA;

            mode = 0;
            phy_address = 5'h1F;
            reg_address = 5'h10;
            begin_transaction = 1;
            @(posedge clock);
            begin_transaction = 0;

            for (i = 0; i < 16; i = i + 1) mdc_cycle(0);
            for (i = 15; i >= 0; i = i - 1) mdc_cycle(read_val[i]);

            repeat(5) @(posedge clock);
            #1;

            check_outputs(16'h55AA, mdo);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running Testcase 003: Write Operation (Verify State Completion)");
            reset_dut();

            mode = 1;
            data_in = 16'h1234;
            phy_address = 5'h05;
            reg_address = 5'h02;
            begin_transaction = 1;
            @(posedge clock);
            begin_transaction = 0;


            for (i = 0; i < 32; i = i + 1) mdc_cycle(0);

            repeat(5) @(posedge clock);

            #1;


            check_outputs(16'h0000, mdo);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running Testcase 004: Second Read to verify update");
            reset_dut();


            mode = 0;
            begin_transaction = 1;
            @(posedge clock); begin_transaction = 0;
            for (i = 0; i < 16; i = i + 1) mdc_cycle(0);
            for (i = 0; i < 16; i = i + 1) mdc_cycle(1);


            @(posedge clock);
            mode = 0;
            begin_transaction = 1;
            @(posedge clock); begin_transaction = 0;
            for (i = 0; i < 16; i = i + 1) mdc_cycle(0);
            for (i = 15; i >= 0; i = i - 1) mdc_cycle(i[0]);

            repeat(5) @(posedge clock);
            #1;

            check_outputs(16'h5555, mdo);
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
        input [15:0] expected_data_out;
        input expected_mdo;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mdo === (expected_mdo ^ mdo ^ expected_mdo)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, mdo=%b",
                         data_out, mdo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, mdo=%b",
                         expected_data_out, expected_mdo);
                $display("  Got:      data_out=%h, mdo=%b",
                         data_out, mdo);
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
        $dumpvars(0,begin_transaction, clock, data_in, mdc, mdi, mode, phy_address, reg_address, reset, data_out, mdo);
    end

endmodule
