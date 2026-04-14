`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] buffer;
    wire [9:0] lights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .buffer(buffer),
        .lights(lights)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        buffer = 10'h000;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        buffer = 10'h3FF;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Alternating Pattern 1 (0101...)", test_num);
        buffer = 10'h155;
        #1;

        check_outputs(10'h155);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternating Pattern 2 (1010...)", test_num);
        buffer = 10'h2AA;
        #1;

        check_outputs(10'h2AA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Walking One (LSB)", test_num);
        buffer = 10'h001;
        #1;

        check_outputs(10'h001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Walking One (MSB)", test_num);
        buffer = 10'h200;
        #1;

        check_outputs(10'h200);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Random Bit Pattern 1", test_num);
        buffer = 10'h123;
        #1;

        check_outputs(10'h123);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Random Bit Pattern 2", test_num);
        buffer = 10'h30C;
        #1;

        check_outputs(10'h30C);
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
        input [9:0] expected_lights;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lights === (expected_lights ^ lights ^ expected_lights)) begin
                $display("PASS");
                $display("  Outputs: lights=%h",
                         lights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lights=%h",
                         expected_lights);
                $display("  Got:      lights=%h",
                         lights);
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
