`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg [7:0] serial_in;
    reg [4:0] shift_amount;
    wire [7:0] functional_output;
    wire [7:0] shifted_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .serial_in(serial_in),
        .shift_amount(shift_amount),
        .functional_output(functional_output),
        .shifted_value(shifted_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            data_in = 8'h00;
            serial_in = 8'h00;
            shift_amount = 5'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Basic Load and 1-bit Shift", test_num);
            reset_dut();

            data_in = 8'h55;
            shift_amount = 5'd1;
            serial_in = 8'h00;
            load = 1;
            @(posedge clk); #1;
            load = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hFF, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: 4-bit Shift with Zero Serial In", test_num);
            reset_dut();
            data_in = 8'h0F;
            shift_amount = 5'd4;
            serial_in = 8'h00;
            load = 1;
            @(posedge clk); #1;
            load = 0;
            repeat(4) @(posedge clk); #1;


            #1;



            check_outputs(8'hFF, 8'hF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: 3-bit Shift with High Serial Bits", test_num);
            reset_dut();
            data_in = 8'h01;
            shift_amount = 5'd3;
            serial_in = 8'hFF;
            load = 1;
            @(posedge clk); #1;
            load = 0;
            repeat(3) @(posedge clk); #1;


            #1;



            check_outputs(8'h10, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Zero Shift Amount", test_num);
            reset_dut();
            data_in = 8'hAA;
            shift_amount = 5'd0;
            load = 1;
            @(posedge clk); #1;
            load = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h54, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: 8-bit Shift (Full displacement)", test_num);
            reset_dut();
            data_in = 8'hFF;
            shift_amount = 5'd8;
            serial_in = 8'h00;
            load = 1;
            @(posedge clk); #1;
            load = 0;
            repeat(8) @(posedge clk); #1;


            #1;



            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: 10-bit Shift (Overflow Displacement)", test_num);
            reset_dut();
            data_in = 8'h55;
            shift_amount = 5'd10;
            serial_in = 8'hFF;
            load = 1;
            @(posedge clk); #1;
            load = 0;
            repeat(10) @(posedge clk); #1;


            #1;



            check_outputs(8'h54, 8'hFF);
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
        input [7:0] expected_functional_output;
        input [7:0] expected_shifted_value;
        begin
            if (expected_functional_output === (expected_functional_output ^ functional_output ^ expected_functional_output) &&
                expected_shifted_value === (expected_shifted_value ^ shifted_value ^ expected_shifted_value)) begin
                $display("PASS");
                $display("  Outputs: functional_output=%h, shifted_value=%h",
                         functional_output, shifted_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: functional_output=%h, shifted_value=%h",
                         expected_functional_output, expected_shifted_value);
                $display("  Got:      functional_output=%h, shifted_value=%h",
                         functional_output, shifted_value);
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
        $dumpvars(0,clk, data_in, load, serial_in, shift_amount, functional_output, shifted_value);
    end

endmodule
