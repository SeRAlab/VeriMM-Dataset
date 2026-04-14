`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    reg [7:0] inant;
    wire count1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .inant(inant),
        .count1(count1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs zero (Equality)", test_num);
            in = 8'h00;
            inant = 8'h00;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs max value (Equality)", test_num);
            in = 8'hFF;
            inant = 8'hFF;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical pattern 0xAA (Equality)", test_num);
            in = 8'hAA;
            inant = 8'hAA;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit difference LSB (Inequality)", test_num);
            in = 8'h01;
            inant = 8'h00;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit difference MSB (Inequality)", test_num);
            in = 8'h80;
            inant = 8'h00;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary patterns (Inequality)", test_num);
            in = 8'h55;
            inant = 8'hAA;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One input zero, one input FF (Inequality)", test_num);
            in = 8'h00;
            inant = 8'hFF;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random values (Inequality)", test_num);
            in = 8'h23;
            inant = 8'h45;
            #10;
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
        input expected_count1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count1 === (expected_count1 ^ count1 ^ expected_count1)) begin
                $display("PASS");
                $display("  Outputs: count1=%b",
                         count1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count1=%b",
                         expected_count1);
                $display("  Got:      count1=%b",
                         count1);
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
