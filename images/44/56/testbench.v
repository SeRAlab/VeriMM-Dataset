`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg reset;
    wire [99:0] final_output;
    wire [5:0] out_not;
    wire [2:0] out_or_bitwise;
    wire out_or_logical;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .reset(reset),
        .final_output(final_output),
        .out_not(out_not),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            load = 0;
            ena = 0;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 3'b101;
            b = 3'b011;





            #1;
            #1;

            check_outputs(100'd0, 6'b100010, 3'b111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 3'b000; b = 3'b000;
            data = 100'h5555555555555555555555555;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(100'h5555555555555555555555555, 6'b111111, 3'b000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data = 100'h1;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(100'h8000000000000000000000000, 6'b111111, 3'b000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data = 100'h8000000000000000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(100'h1, 6'b111111, 3'b000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 3'b110; b = 3'b000;
            data = 100'hA000000000000000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b10;
            @(posedge clk);
            @(posedge clk);
            #1;




            #1;





            check_outputs(100'h8000000000000000000000002, 6'b111001, 3'b110, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data = 100'hFEDCBA9876543210FEDCBA987;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b00;
            @(posedge clk);
            ena = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'hFEDCBA9876543210FEDCBA987, 6'b111111, 3'b000, 1'b0);
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
        input [99:0] expected_final_output;
        input [5:0] expected_out_not;
        input [2:0] expected_out_or_bitwise;
        input expected_out_or_logical;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_or_bitwise === (expected_out_or_bitwise ^ out_or_bitwise ^ expected_out_or_bitwise) &&
                expected_out_or_logical === (expected_out_or_logical ^ out_or_logical ^ expected_out_or_logical)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         final_output, out_not, out_or_bitwise, out_or_logical);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         expected_final_output, expected_out_not, expected_out_or_bitwise, expected_out_or_logical);
                $display("  Got:      final_output=%h, out_not=%h, out_or_bitwise=%h, out_or_logical=%b",
                         final_output, out_not, out_or_bitwise, out_or_logical);
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
        $dumpvars(0,a, b, clk, data, ena, load, reset, final_output, out_not, out_or_bitwise, out_or_logical);
    end

endmodule
