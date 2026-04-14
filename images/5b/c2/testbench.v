`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg [99:0] in;
    reg load;
    wire [99:0] final_output;
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
        .data(data),
        .ena(ena),
        .in(in),
        .load(load),
        .final_output(final_output),
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
            load = 0;
            ena = 2'b00;
            data = 100'd0;
            in = 100'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Load, No Shift, Logical Check", test_num);
            load = 1;
            ena = 2'b00;
            data = 100'h5555555555555555555555555;
            in   = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #1;





            #1;






            check_outputs(100'hFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b0, 1'b1, 1'b0, 100'h5555555555555555555555555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Shift Left", test_num);
            load = 1;
            ena = 2'b10;
            data = 100'h1;
            in   = 100'h0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(100'h2, 1'b0, 1'b1, 1'b1, 100'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Shift Right", test_num);
            load = 1;
            ena = 2'b01;
            data = 100'h2;
            in   = 100'h0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(100'h1, 1'b0, 1'b1, 1'b1, 100'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Load Disable Check", test_num);

            load = 1; ena = 2'b00; data = 100'hABC; in = 100'h0;
            @(posedge clk);
            #1;

            load = 0; data = 100'hFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(100'hABC, 1'b0, 1'b1, 1'b1, 100'hABC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: All Ones Reduction Check", test_num);
            load = 1;
            ena = 2'b00;
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            in   = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;



            #1;




            check_outputs(100'hFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b1, 1'b1, 1'b0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        input [99:0] expected_final_output;
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        input [99:0] expected_q;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         final_output, out_and, out_or, out_xor, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         expected_final_output, expected_out_and, expected_out_or, expected_out_xor, expected_q);
                $display("  Got:      final_output=%h, out_and=%b, out_or=%b, out_xor=%b, q=%h",
                         final_output, out_and, out_or, out_xor, q);
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
        $dumpvars(0,clk, data, ena, in, load, final_output, out_and, out_or, out_xor, q);
    end

endmodule
