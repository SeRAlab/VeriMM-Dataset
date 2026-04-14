`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg load;
    reg shift;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .load(load),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        load = 0;
        forever #5 load = ~load;
    end

        task reset_dut;

    begin
        load = 1;
        shift = 0;
        data_in = 4'b0000;
        @(posedge clk);
        #1;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        data_in = 4'b1010;
        load = 1;
        shift = 0;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        data_in = 4'b0101;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        shift = 1;
        @(posedge clk);
        #1;
        shift = 0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        data_in = 4'b1100;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        shift = 0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        data_in = 4'b1111;
        load = 1;
        shift = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift = 0;

        #1;


        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        data_in = 4'b0110;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift = 0;
        data_in = 4'b1111;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,data_in, load, shift, out);
    end

endmodule
