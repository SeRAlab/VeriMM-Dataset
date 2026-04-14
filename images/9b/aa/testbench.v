`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg incr_cntl;
    reg [31:0] incr_val;
    reg resetn;
    reg shift;
    reg shift_in;
    wire [31:0] data_out;
    wire shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .incr_cntl(incr_cntl),
        .incr_val(incr_val),
        .resetn(resetn),
        .shift(shift),
        .shift_in(shift_in),
        .data_out(data_out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        resetn = 0;
        enable = 0;
        shift = 0;
        incr_cntl = 0;
        incr_val = 0;
        shift_in = 0;
        #10;
        resetn = 1;
        #10;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Increment", test_num);
        reset_dut();

        enable = 1;
        incr_cntl = 1;
        incr_val = 32'h0000_ABCD;
        shift = 0;

        @(posedge clock);
        #1;


        #1;



        check_outputs(32'h0000_ABCD, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Accumulation Check", test_num);
        reset_dut();

        enable = 1;
        incr_cntl = 1;
        incr_val = 32'h0000_0005;
        shift = 0;

        repeat(10) @(posedge clock);
        #1;


        #1;



        check_outputs(32'h0000_0032, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Increment Control Disable", test_num);
        reset_dut();

        enable = 1;
        incr_cntl = 0;
        incr_val = 32'hFFFF_FFFF;
        shift = 0;

        repeat(5) @(posedge clock);
        #1;

        #1;


        check_outputs(32'h0000_0000, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Global Enable Disable", test_num);
        reset_dut();

        enable = 0;
        incr_cntl = 1;
        incr_val = 32'h0000_0001;
        shift = 0;

        repeat(5) @(posedge clock);
        #1;

        #1;


        check_outputs(32'h0000_0000, 0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift 32 bits in", test_num);
        reset_dut();

        enable = 1;
        shift = 1;
        incr_cntl = 0;



        for (i = 0; i < 32; i = i + 1) begin
            shift_in = (i % 2 == 0) ? 1 : 0;
            @(posedge clock);
            #1;
        end

        shift = 0;


        #1;



        check_outputs(32'h5555_5555, 0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift through 64 bits (Shift-out check)", test_num);
        reset_dut();

        enable = 1;
        shift = 1;


        shift_in = 1;
        @(posedge clock);
        #1;


        shift_in = 0;
        repeat(63) begin
            @(posedge clock);
            #1;
        end



        #1;




        check_outputs(32'h0000_0000, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Lower 32-bit Overflow", test_num);
        reset_dut();

        enable = 1;
        shift = 0;
        incr_cntl = 1;


        incr_val = 32'hFFFF_FFFF;
        @(posedge clock);
        #1;


        incr_val = 32'h0000_0001;
        @(posedge clock);
        #1;


        #1;



        check_outputs(32'h0000_0000, 0);
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
        input [31:0] expected_data_out;
        input expected_shift_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, shift_out=%b",
                         data_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, shift_out=%b",
                         expected_data_out, expected_shift_out);
                $display("  Got:      data_out=%h, shift_out=%b",
                         data_out, shift_out);
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
        $dumpvars(0,clock, enable, incr_cntl, incr_val, resetn, shift, shift_in, data_out, shift_out);
    end

endmodule
