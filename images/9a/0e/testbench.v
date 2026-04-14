`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .q(q)
    );
    task testcase000;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 0 (3'b000)", test_num);
            in = 3'b000;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 1 (3'b001)", test_num);
            in = 3'b001;
            #1;

            check_outputs(8'b0000_0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 2 (3'b010)", test_num);
            in = 3'b010;
            #1;

            check_outputs(8'b0000_0100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 3 (3'b011)", test_num);
            in = 3'b011;
            #1;

            check_outputs(8'b0000_1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4 (3'b100)", test_num);
            in = 3'b100;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 5 (3'b101)", test_num);
            in = 3'b101;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 6 (3'b110)", test_num);
            in = 3'b110;
            #1;

            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 7 (3'b111)", test_num);
            in = 3'b111;
            #1;

            check_outputs(8'b1000_0000);
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


        testcase000();
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
        input [7:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
