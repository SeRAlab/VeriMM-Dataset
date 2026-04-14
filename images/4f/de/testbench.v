`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d0;
    reg [3:0] d1;
    reg s;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d0(d0),
        .d1(d1),
        .s(s),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select d0, d0=4'h0, d1=4'hF", test_num);
            d0 = 4'h0;
            d1 = 4'hF;
            s  = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select d0, d0=4'hA, d1=4'h5", test_num);
            d0 = 4'hA;
            d1 = 4'h5;
            s  = 1'b0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select d1, d0=4'h0, d1=4'hF", test_num);
            d0 = 4'h0;
            d1 = 4'hF;
            s  = 1'b1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select d1, d0=4'hA, d1=4'h5", test_num);
            d0 = 4'hA;
            d1 = 4'h5;
            s  = 1'b1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select d0, d0=4'hF, d1=4'h0", test_num);
            d0 = 4'hF;
            d1 = 4'h0;
            s  = 1'b0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select d1, d0=4'hF, d1=4'h0", test_num);
            d0 = 4'hF;
            d1 = 4'h0;
            s  = 1'b1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select d0, d0=4'h3, d1=4'hC", test_num);
            d0 = 4'h3;
            d1 = 4'hC;
            s  = 1'b0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select d1, d0=4'h3, d1=4'hC", test_num);
            d0 = 4'h3;
            d1 = 4'hC;
            s  = 1'b1;
            #1;

            check_outputs(4'hC);
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
