`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: en=0, in=4'b1111 - Output should be 0", test_num);
            en = 1'b0;
            in = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: en=1, in=4'b0000 - Output should be 0", test_num);
            en = 1'b1;
            in = 4'b0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: en=1, in=4'b0001 - Output should be 1 (in[0] is high)", test_num);
            en = 1'b1;
            in = 4'b0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: en=1, in=4'b0010 - Output should be 1 (in[1] is high)", test_num);
            en = 1'b1;
            in = 4'b0010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: en=1, in=4'b0100 - Output should be 1 (in[2] is high)", test_num);
            en = 1'b1;
            in = 4'b0100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: en=1, in=4'b1000 - Output should be 1 (in[3] is high)", test_num);
            en = 1'b1;
            in = 4'b1000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: en=1, in=4'b1011 - Output should be 1 (multiple bits high)", test_num);
            en = 1'b1;
            in = 4'b1011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: en=0, in=4'b0001 - Output should be 0 when en is low", test_num);
            en = 1'b0;
            in = 4'b0001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: en=1, in=4'b1111 - Output should be 1", test_num);
            en = 1'b1;
            in = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: en=0, in=4'b0000 - Output should be 0", test_num);
            en = 1'b0;
            in = 4'b0000;
            #1;

            check_outputs(1'b0);
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
        testcase010();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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

endmodule
