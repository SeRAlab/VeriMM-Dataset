`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a_in;
    reg [7:0] b_in;
    reg clock;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .clock(clock),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            a_in = 8'h00;
            b_in = 8'h00;
            @(posedge clock);
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Inputs (AA, 55)", test_num);
            a_in = 8'hAA;
            b_in = 8'h55;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Bits High", test_num);
            a_in = 8'hFF;
            b_in = 8'hFF;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Bits Low", test_num);
            a_in = 8'h00;
            b_in = 8'h00;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Nibble Swap", test_num);
            a_in = 8'hF0;
            b_in = 8'h0F;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: B covers A bits", test_num);
            a_in = 8'h0F;
            b_in = 8'hFF;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Bits", test_num);
            a_in = 8'h55;
            b_in = 8'hAA;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overlap", test_num);
            a_in = 8'hC3;
            b_in = 8'h3C;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h3C);
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
        $dumpvars(0,a_in, b_in, clock, out);
    end

endmodule
