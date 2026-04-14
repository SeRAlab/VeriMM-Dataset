`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg [2:0] y;
    wire Y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .y(y),
        .Y2(Y2)
    );
    task testcase001;

        begin
            test_num = 1;
            y = 3'b000;
            w = 1'b0;
            $display("Testcase %0d: State J (000), w=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            y = 3'b000;
            w = 1'b1;
            $display("Testcase %0d: State J (000), w=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            y = 3'b001;
            w = 1'b0;
            $display("Testcase %0d: State K (001), w=0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            y = 3'b001;
            w = 1'b1;
            $display("Testcase %0d: State K (001), w=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            y = 3'b010;
            w = 1'b0;
            $display("Testcase %0d: State L (010), w=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            y = 3'b010;
            w = 1'b1;
            $display("Testcase %0d: State L (010), w=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            y = 3'b011;
            w = 1'b0;
            $display("Testcase %0d: State M (011), w=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            y = 3'b011;
            w = 1'b1;
            $display("Testcase %0d: State M (011), w=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            y = 3'b100;
            w = 1'b0;
            $display("Testcase %0d: State N (100), w=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            y = 3'b100;
            w = 1'b1;
            $display("Testcase %0d: State N (100), w=1", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_Y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y2=%b",
                         Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y2=%b",
                         expected_Y2);
                $display("  Got:      Y2=%b",
                         Y2);
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
