`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    reg shift;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            shift = 0;
            in = 8'h00;
            @(negedge clk);
            reset = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift single bit '1'", test_num);
            reset_dut();
            @(negedge clk);
            shift = 1;
            in = 8'h01;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill register with 0xAA", test_num);
            reset_dut();
            data_to_shift = 8'hAA;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                shift = 1;
                in = {7'b0, data_to_shift[7-i]};
            end
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data_to_shift;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill register with 0x55", test_num);
            reset_dut();
            data_to_shift = 8'h55;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                shift = 1;
                in = {7'b0, data_to_shift[7-i]};
            end
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify shift disable (Hold)", test_num);
            reset_dut();

            @(negedge clk);
            shift = 1; in = 8'h01;
            @(negedge clk);
            shift = 1; in = 8'h01;
            @(negedge clk);
            shift = 1; in = 8'h01;
            @(negedge clk);
            shift = 1; in = 8'h01;
            @(negedge clk);
            shift = 0; in = 8'h00;
            @(negedge clk);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow check (Shift 10 times)", test_num);
            reset_dut();

            @(negedge clk);
            shift = 1;
            in = 8'h01;
            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
            end
            shift = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-operation reset", test_num);
            reset_dut();
            @(negedge clk);
            shift = 1; in = 8'h01;
            @(negedge clk);
            shift = 1; in = 8'h01;

            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_out;
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
        $dumpvars(0,clk, in, reset, shift, out);
    end

endmodule
