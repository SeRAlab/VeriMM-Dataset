`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [15:0] in0;
    reg in0_empty;
    reg out0_full;
    reg reset;
    wire in0_rd;
    wire [15:0] out0;
    wire out0_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in0(in0),
        .in0_empty(in0_empty),
        .out0_full(out0_full),
        .reset(reset),
        .in0_rd(in0_rd),
        .out0(out0),
        .out0_wr(out0_wr)
    );
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            in0 = 16'h0000; in0_empty = 1; out0_full = 0;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'hAAAA; in0_empty = 0; out0_full = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b1, 16'h5555, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'hFFFF; in0_empty = 1; out0_full = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 16'hx, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'hFFFF; in0_empty = 0; out0_full = 1;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 16'hx, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'h0001; in0_empty = 0; out0_full = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b1, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'h8000; in0_empty = 0; out0_full = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b1, 16'h4000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'hFFFF; in0_empty = 0; out0_full = 0;
            @(posedge clock);
            #1;

            check_outputs(1'b1, 16'h7FFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset = 1;
            @(posedge clock);
            #1 reset = 0;
            in0 = 16'h1234; in0_empty = 1; out0_full = 1;
            @(posedge clock);
            #1;

            check_outputs(1'b0, 16'hx, 1'b0);
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
        input expected_in0_rd;
        input [15:0] expected_out0;
        input expected_out0_wr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in0_rd === (expected_in0_rd ^ in0_rd ^ expected_in0_rd) &&
                expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out0_wr === (expected_out0_wr ^ out0_wr ^ expected_out0_wr)) begin
                $display("PASS");
                $display("  Outputs: in0_rd=%b, out0=%h, out0_wr=%b",
                         in0_rd, out0, out0_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in0_rd=%b, out0=%h, out0_wr=%b",
                         expected_in0_rd, expected_out0, expected_out0_wr);
                $display("  Got:      in0_rd=%b, out0=%h, out0_wr=%b",
                         in0_rd, out0, out0_wr);
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
