`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg shift_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_en(shift_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        load <= 1;
        data_in <= 16'h0000;
        shift_en <= 0;
        @(posedge clk);
        load <= 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load 16'hA5A5", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 16'hA5A5;
        @(posedge clk);
        load <= 0;
        #1;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load 16'h0001 then Shift Left once", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 16'h0001;
        @(posedge clk);
        load <= 0;
        shift_en <= 1;
        @(posedge clk);
        shift_en <= 0;
        #1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load 16'h00FF then Shift Left 4 times", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 16'h00FF;
        @(posedge clk);
        load <= 0;
        shift_en <= 1;
        repeat(4) @(posedge clk);
        shift_en <= 0;
        #1;
        #1;

        check_outputs(16'h0FF0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load 16'h8000 then Shift Left once (expect 0)", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 16'h8000;
        @(posedge clk);
        load <= 0;
        shift_en <= 1;
        @(posedge clk);
        shift_en <= 0;
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load and Shift simultaneously (Load should win)", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 16'h1234;
        shift_en <= 1;
        @(posedge clk);
        load <= 0;
        shift_en <= 0;
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Disable Load and Shift (Value should hold)", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 16'hFEDC;
        @(posedge clk);
        load <= 0;
        shift_en <= 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFEDC);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, shift_en, data_out);
    end

endmodule
