`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] cn;
    wire [16:0] price;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cn(cn),
        .price(price)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 0 (Lower bound of tier 1)", test_num);
            cn = 10'd0;
            #1;

            check_outputs(17'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 128 (Middle of tier 1)", test_num);
            cn = 10'd128;
            #1;

            check_outputs(17'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 255 (Upper bound of tier 1)", test_num);
            cn = 10'd255;
            #1;

            check_outputs(17'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 256 (Lower bound of tier 2)", test_num);
            cn = 10'd256;
            #1;

            check_outputs(17'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 400 (Middle of tier 2)", test_num);
            cn = 10'd400;
            #1;

            check_outputs(17'd500);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 511 (Upper bound of tier 2)", test_num);
            cn = 10'd511;
            #1;

            check_outputs(17'd500);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 512 (Lower bound of tier 3)", test_num);
            cn = 10'd512;
            #1;

            check_outputs(17'd1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 750 (Middle of tier 3)", test_num);
            cn = 10'd750;
            #1;

            check_outputs(17'd1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cn = 1023 (Max value for 10-bit input)", test_num);
            cn = 10'd1023;
            #1;

            check_outputs(17'd1000);
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
        input [16:0] expected_price;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_price === (expected_price ^ price ^ expected_price)) begin
                $display("PASS");
                $display("  Outputs: price=%h",
                         price);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: price=%h",
                         expected_price);
                $display("  Got:      price=%h",
                         price);
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
