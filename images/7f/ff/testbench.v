`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [2:0] in;
    reg load;
    reg reset;
    reg [1:0] select;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .in(in),
        .load(load),
        .reset(reset),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        select = 0;
        in = 0;
        data = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Check", test_num);
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load from Data", test_num);
        reset_dut();
        data = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select Mode 0 (Pass input in)", test_num);
        reset_dut();
        in = 3'b110;
        select = 2'b00;
        load = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select Mode 1 (Right rotation)", test_num);
        reset_dut();

        data = 100'h4;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        select = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select Mode 2 (Left rotation)", test_num);
        reset_dut();

        data = 100'h4;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        select = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Right rotation wrap-around", test_num);
        reset_dut();
        data = 100'h1;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        select = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Left rotation wrap-around", test_num);
        reset_dut();
        data = 100'h1;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        select = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load priority check", test_num);
        reset_dut();
        in = 3'b000;
        select = 2'b01;
        data = 100'h7;
        load = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multi-cycle Left rotation", test_num);
        reset_dut();
        data = 100'h1;
        load = 1;
        @(posedge clk);
        #1 load = 0; select = 2'b10;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(3'b100);
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
        testcase008();
        testcase009();
        
        
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
        input [2:0] expected_out;
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
        $dumpvars(0,clk, data, in, load, reset, select, out);
    end

endmodule
