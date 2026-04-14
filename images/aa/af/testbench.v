`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg reset;
    wire [15:0] address;
    wire load;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .address(address),
        .load(load),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Check outputs when reset is HIGH", test_num);


        clk = 0;
        reset = 1;


        #20;
        #1;

        check_outputs(16'h0000, 1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Check outputs after reset is released (normal operation)", test_num);


        reset = 1;
        #10;
        reset = 0;


        repeat (10) begin
            clk = 1; #5;
            clk = 0; #5;
        end


        #1;



        check_outputs(16'h0000, 1'b0, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Stress test with many clock cycles", test_num);


        reset = 0;


        repeat (100) begin
            clk = ~clk;
            #5;
        end


        #1;



        check_outputs(16'h0000, 1'b0, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Check outputs after a mid-simulation reset", test_num);


        reset = 0;
        repeat (5) begin
            clk = 1; #5;
            clk = 0; #5;
        end


        reset = 1;
        #20;
        reset = 0;
        #10;


        #1;



        check_outputs(16'h0000, 1'b0, 16'h0000);
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
        input [15:0] expected_address;
        input expected_load;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_load === (expected_load ^ load ^ expected_load) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: address=%h, load=%b, out=%h",
                         address, load, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, load=%b, out=%h",
                         expected_address, expected_load, expected_out);
                $display("  Got:      address=%h, load=%b, out=%h",
                         address, load, out);
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

endmodule
