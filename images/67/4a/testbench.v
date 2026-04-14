`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IN_0;
    reg IN_1;
    reg SW;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN_0(IN_0),
        .IN_1(IN_1),
        .SW(SW),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            IN_0 = 0; IN_1 = 0; SW = 0;
            $display("Testcase %0d: SW=0 (Select IN_0), IN_0=0, IN_1=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            IN_0 = 1; IN_1 = 0; SW = 0;
            $display("Testcase %0d: SW=0 (Select IN_0), IN_0=1, IN_1=0", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            IN_0 = 0; IN_1 = 1; SW = 0;
            $display("Testcase %0d: SW=0 (Select IN_0), IN_0=0, IN_1=1", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            IN_0 = 1; IN_1 = 1; SW = 0;
            $display("Testcase %0d: SW=0 (Select IN_0), IN_0=1, IN_1=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            IN_0 = 0; IN_1 = 0; SW = 1;
            $display("Testcase %0d: SW=1 (Select IN_1), IN_0=0, IN_1=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            IN_0 = 0; IN_1 = 1; SW = 1;
            $display("Testcase %0d: SW=1 (Select IN_1), IN_0=0, IN_1=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            IN_0 = 1; IN_1 = 0; SW = 1;
            $display("Testcase %0d: SW=1 (Select IN_1), IN_0=1, IN_1=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            IN_0 = 1; IN_1 = 1; SW = 1;
            $display("Testcase %0d: SW=1 (Select IN_1), IN_0=1, IN_1=1", test_num);
            #1;

            check_outputs(1);
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
        input expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
