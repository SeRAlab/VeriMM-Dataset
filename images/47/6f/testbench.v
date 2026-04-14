`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ena;
    reg [99:0] in;
    reg load;
    reg reset;
    wire out_and;
    wire out_or;
    wire out_xor;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .in(in),
        .load(load),
        .reset(reset),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .q(q)
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
            ena = 2'b00;
            in = 100'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Idle state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 100'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Logical reduction (All 1s)", test_num);
            reset_dut();
            in = {100{1'b1}};
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 100'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Logical reduction (Single 1)", test_num);
            reset_dut();
            in = 100'h1;
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 100'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Synchronous Load", test_num);
            reset_dut();
            in = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 100'hA5A5A5A5A5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Rotate Right (Wrap around bit 0 to 99)", test_num);
            reset_dut();
            in = 100'h1;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 100'h8000000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Rotate Left (Wrap around bit 99 to 0)", test_num);
            reset_dut();
            in = 100'h8000000000000000000000000;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 100'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load Priority", test_num);
            reset_dut();
            in = 100'hF;
            load = 1;
            ena = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 100'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Multiple Rotate Lefts", test_num);
            reset_dut();
            in = 100'h1;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 100'h4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: No shifting on ena=00 or 11", test_num);
            reset_dut();
            in = 100'hABC;
            load = 1;
            @(posedge clk);
            load = 0;
            ena = 2'b00;
            @(posedge clk);
            ena = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 100'hABC);
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
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        input [99:0] expected_q;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         out_and, out_or, out_xor, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         expected_out_and, expected_out_or, expected_out_xor, expected_q);
                $display("  Got:      out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         out_and, out_or, out_xor, q);
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
        $dumpvars(0,clk, ena, in, load, reset, out_and, out_or, out_xor, q);
    end

endmodule
