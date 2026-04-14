`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] data;
    reg load;
    reg reset;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        load = 0;
        data = 0;
        @(posedge clk);
        #1;
        reset = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        load = 1;
        data = 6'b101010;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(6'b101010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        load = 1;
        data = 6'b110000;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(6'b011000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        load = 1;
        data = 6'b000001;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(6'b100000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        load = 1;
        data = 6'b111000;
        @(posedge clk);
        #1;
        load = 0;
        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(6'b000111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        load = 1;
        data = 6'b101101;
        @(posedge clk);
        #1;
        load = 0;
        repeat(6) @(posedge clk);
        #1;

        #1;


        check_outputs(6'b101101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        load = 1;
        data = 6'b111111;
        reset = 0;
        @(posedge clk);
        #1;
        reset = 1;
        #1;

        check_outputs(6'b000000);
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
        input [5:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, load, reset, q);
    end

endmodule
