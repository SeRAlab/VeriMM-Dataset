`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [49:0] in;
    reg reset;
    wire out_nand;
    wire out_nor;
    wire out_xnor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out_nand(out_nand),
        .out_nor(out_nor),
        .out_xnor(out_xnor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Task: Resetting DUT...");
            reset = 1;
            in = 50'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Post-reset, All Zeros Input", test_num);
            reset_dut();

            in = 50'h0;




            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Ones Input", test_num);
            reset_dut();

            in = 50'h3_FFFF_FFFF_FFFF;




            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Bit High Input", test_num);
            reset_dut();

            in = 50'h0000_0000_0001;




            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Johnson Counter MSB Shift (Clocking)", test_num);
            reset_dut();

            in = 50'h0;



            repeat(8) @(posedge clk);

            #1;



            $display("Checking output after 8 clock cycles...");
            #1;

            check_outputs(out_nand, out_nor, ~(1'b1 ^ out_nand ^ out_nor));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Random Logic Check", test_num);
            reset_dut();

            in = 50'h1234_5678_9ABC;
            #1;





            #1;






            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary Check (49 bits high)", test_num);
            reset_dut();

            in = 50'h3_FFFF_FFFF_FFFE;
            #1;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_out_nand;
        input expected_out_nor;
        input expected_out_xnor;
        begin
            if (expected_out_nand === (expected_out_nand ^ out_nand ^ expected_out_nand) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor)) begin
                $display("PASS");
                $display("  Outputs: out_nand=%b, out_nor=%b, out_xnor=%b",
                         out_nand, out_nor, out_xnor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_nand=%b, out_nor=%b, out_xnor=%b",
                         expected_out_nand, expected_out_nor, expected_out_xnor);
                $display("  Got:      out_nand=%b, out_nor=%b, out_xnor=%b",
                         out_nand, out_nor, out_xnor);
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
        $dumpvars(0,clk, in, reset, out_nand, out_nor, out_xnor);
    end

endmodule
