`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg [2:0] v;
    wire V2;
    wire V3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .v(v),
        .V2(V2),
        .V3(V3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: State H (v=3'b001), d=0", test_num);
            d = 0;
            v = 3'b001;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State H (v=3'b001), d=1", test_num);
            d = 1;
            v = 3'b001;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State I (v=3'b010), d=0", test_num);
            d = 0;
            v = 3'b010;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State I (v=3'b010), d=1", test_num);
            d = 1;
            v = 3'b010;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State J (v=3'b100), d=0", test_num);
            d = 0;
            v = 3'b100;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State J (v=3'b100), d=1", test_num);
            d = 1;
            v = 3'b100;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: All-zero state (v=3'b000), d=1", test_num);
            d = 1;
            v = 3'b000;

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_V2;
        input expected_V3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V2 === (expected_V2 ^ V2 ^ expected_V2) &&
                expected_V3 === (expected_V3 ^ V3 ^ expected_V3)) begin
                $display("PASS");
                $display("  Outputs: V2=%b, V3=%b",
                         V2, V3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V2=%b, V3=%b",
                         expected_V2, expected_V3);
                $display("  Got:      V2=%b, V3=%b",
                         V2, V3);
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
