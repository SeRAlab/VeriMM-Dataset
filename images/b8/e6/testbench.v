`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [3:0] in;
    wire out_and;
    wire out_not;
    wire out_or;
    wire out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out_and(out_and),
        .out_not(out_not),
        .out_or(out_or),
        .out_xor(out_xor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;




            if (in !== 4'b0000) begin
                repeat (16) begin
                    if (in !== 4'b0000) @(posedge clk);
                end
            end
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test Case 001: Input 0000");




            #1;





            check_outputs(4'b0000, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            $display("Test Case 002: Input 0001");




            #1;





            check_outputs(4'b0001, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            $display("Test Case 003: Input 0011");




            #1;





            check_outputs(4'b0011, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            $display("Test Case 004: Input 0111");




            #1;





            check_outputs(4'b0111, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            $display("Test Case 005: Input 1000");




            #1;





            check_outputs(4'b1000, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            $display("Test Case 006: Input 1111");




            #1;





            check_outputs(4'b1111, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            $display("Test Case 007: Input 0100");




            #1;





            check_outputs(4'b0100, 1'b0, 1'b1, 1'b1, 1'b1);
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
        input [3:0] expected_in;
        input expected_out_and;
        input expected_out_not;
        input expected_out_or;
        input expected_out_xor;
        begin
            if (expected_in === (expected_in ^ in ^ expected_in) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: in=%h, out_and=%b, out_not=%b, out_or=%b, out_xor=%b",
                         in, out_and, out_not, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in=%h, out_and=%b, out_not=%b, out_or=%b, out_xor=%b",
                         expected_in, expected_out_and, expected_out_not, expected_out_or, expected_out_xor);
                $display("  Got:      in=%h, out_and=%b, out_not=%b, out_or=%b, out_xor=%b",
                         in, out_and, out_not, out_or, out_xor);
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
        $dumpvars(0,clk, in, out_and, out_not, out_or, out_xor);
    end

endmodule
