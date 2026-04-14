`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [4:0] in;
    reg reset;
    reg select;
    wire [2:0] final_output;
    wire out_and;
    wire out_nor;
    wire out_or;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .reset(reset),
        .select(select),
        .final_output(final_output),
        .out_and(out_and),
        .out_nor(out_nor),
        .out_or(out_or)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            in = 5'b0;
            select = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset state and default logic");
            reset_dut();


            #1;



            check_outputs(3'b000, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Logic gates with all inputs HIGH");
            reset_dut();
            in = 5'b11111;
            select = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(3'b111, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift register sequence 1-0-1");
            reset_dut();
            select = 0;

            d = 1; @(posedge clk); #1;
            d = 0; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;



            #1;




            check_outputs(3'b101, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiplexer toggle between Shift Register and Input");
            reset_dut();


            d = 1; select = 0;
            repeat(3) @(posedge clk);
            #1;


            in = 5'b01010;


            select = 0;
            #1;

            if (final_output !== 3'b111) $display("Error: Select 0 failed");


            select = 1;
            #2;

            #1;


            check_outputs(3'b010, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: NOR operation check");
            reset_dut();
            in = 5'b00000;
            #1;

            #1;


            check_outputs(3'b000, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift register overflow (4 bits in 3-bit register)");
            reset_dut();
            select = 0;

            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(3'b101, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: MSB bit influence check");
            reset_dut();
            select = 1;
            in = 5'b10000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(3'b000, 1'b0, 1'b0, 1'b1);
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
        input [2:0] expected_final_output;
        input expected_out_and;
        input expected_out_nor;
        input expected_out_or;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, out_and=%b, out_nor=%b, out_or=%b",
                         final_output, out_and, out_nor, out_or);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, out_and=%b, out_nor=%b, out_or=%b",
                         expected_final_output, expected_out_and, expected_out_nor, expected_out_or);
                $display("  Got:      final_output=%h, out_and=%b, out_nor=%b, out_or=%b",
                         final_output, out_and, out_nor, out_or);
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
        $dumpvars(0,clk, d, in, reset, select, final_output, out_and, out_nor, out_or);
    end

endmodule
