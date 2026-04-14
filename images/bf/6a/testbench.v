`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] dest_init;
    reg head_init;
    reg tail_init;
    wire [9:0] dest;
    wire head;
    wire tail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dest_init(dest_init),
        .head_init(head_init),
        .tail_init(tail_init),
        .dest(dest),
        .head(head),
        .tail(tail)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initializing packet header (head=1, tail=0)", test_num);
            head_init = 1'b1;
            tail_init = 1'b0;
            dest_init = 10'h0A5;
            #1;

            check_outputs(10'h0A5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Initializing packet tail (head=0, tail=1)", test_num);
            head_init = 1'b0;
            tail_init = 1'b1;
            dest_init = 10'h3FF;
            #1;

            check_outputs(10'h3FF, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Initializing single-word packet (head=1, tail=1)", test_num);
            head_init = 1'b1;
            tail_init = 1'b1;
            dest_init = 10'h000;
            #1;

            check_outputs(10'h000, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Initializing mid-packet data (head=0, tail=0)", test_num);
            head_init = 1'b0;
            tail_init = 1'b0;
            dest_init = 10'h2AA;
            #1;

            check_outputs(10'h2AA, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Resetting/Clearing all signals", test_num);
            head_init = 1'b0;
            tail_init = 1'b0;
            dest_init = 10'h000;
            #1;

            check_outputs(10'h000, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Maximum destination address with header", test_num);
            head_init = 1'b1;
            tail_init = 1'b0;
            dest_init = 10'h3FF;
            #1;

            check_outputs(10'h3FF, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Pattern check 0x155", test_num);
            head_init = 1'b0;
            tail_init = 1'b1;
            dest_init = 10'h155;
            #1;

            check_outputs(10'h155, 1'b0, 1'b1);
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
        input [9:0] expected_dest;
        input expected_head;
        input expected_tail;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dest === (expected_dest ^ dest ^ expected_dest) &&
                expected_head === (expected_head ^ head ^ expected_head) &&
                expected_tail === (expected_tail ^ tail ^ expected_tail)) begin
                $display("PASS");
                $display("  Outputs: dest=%h, head=%b, tail=%b",
                         dest, head, tail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dest=%h, head=%b, tail=%b",
                         expected_dest, expected_head, expected_tail);
                $display("  Got:      dest=%h, head=%b, tail=%b",
                         dest, head, tail);
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
