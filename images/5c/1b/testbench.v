`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg GND;
    reg VCC;
    reg \\6A_A;
    reg \\6A_B;
    reg \\6A_C;
    reg \\6A_D;
    reg \\6A_E;
    wire \\6Y_A;
    wire \\6Y_B;
    wire \\6Y_C;
    wire \\6Y_D;
    wire \\6Y_E;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GND(GND),
        .VCC(VCC),
        .\\6A_A(\\6A_A),
        .\\6A_B(\\6A_B),
        .\\6A_C(\\6A_C),
        .\\6A_D(\\6A_D),
        .\\6A_E(\\6A_E),
        .\\6Y_A(\\6Y_A),
        .\\6Y_B(\\6Y_B),
        .\\6Y_C(\\6Y_C),
        .\\6Y_D(\\6Y_D),
        .\\6Y_E(\\6Y_E)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Testing all inputs set to 0", test_num);
        GND = 0; VCC = 1;
        \\6A_A = 0; \\6A_B = 0; \\6A_C = 0; \\6A_D = 0; \\6A_E = 0;
        #1;

        check_outputs(1, 1, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Testing all inputs set to 1", test_num);
        GND = 0; VCC = 1;
        \\6A_A = 1; \\6A_B = 1; \\6A_C = 1; \\6A_D = 1; \\6A_E = 1;
        #1;

        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Testing alternating pattern 10101", test_num);
        GND = 0; VCC = 1;
        \\6A_A = 1; \\6A_B = 0; \\6A_C = 1; \\6A_D = 0; \\6A_E = 1;
        #1;

        check_outputs(0, 1, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Testing alternating pattern 01010", test_num);
        GND = 0; VCC = 1;
        \\6A_A = 0; \\6A_B = 1; \\6A_C = 0; \\6A_D = 1; \\6A_E = 0;
        #1;

        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Testing mixed pattern 11001", test_num);
        GND = 0; VCC = 1;
        \\6A_A = 1; \\6A_B = 1; \\6A_C = 0; \\6A_D = 0; \\6A_E = 1;
        #1;

        check_outputs(0, 0, 1, 1, 0);
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
        input expected_\\6Y_A;
        input expected_\\6Y_B;
        input expected_\\6Y_C;
        input expected_\\6Y_D;
        input expected_\\6Y_E;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_\\6Y_A === (expected_\\6Y_A ^ \\6Y_A ^ expected_\\6Y_A) &&
                expected_\\6Y_B === (expected_\\6Y_B ^ \\6Y_B ^ expected_\\6Y_B) &&
                expected_\\6Y_C === (expected_\\6Y_C ^ \\6Y_C ^ expected_\\6Y_C) &&
                expected_\\6Y_D === (expected_\\6Y_D ^ \\6Y_D ^ expected_\\6Y_D) &&
                expected_\\6Y_E === (expected_\\6Y_E ^ \\6Y_E ^ expected_\\6Y_E)) begin
                $display("PASS");
                $display("  Outputs: \\6Y_A=%b, \\6Y_B=%b, \\6Y_C=%b, \\6Y_D=%b, \\6Y_E=%b",
                         \\6Y_A, \\6Y_B, \\6Y_C, \\6Y_D, \\6Y_E);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: \\6Y_A=%b, \\6Y_B=%b, \\6Y_C=%b, \\6Y_D=%b, \\6Y_E=%b",
                         expected_\\6Y_A, expected_\\6Y_B, expected_\\6Y_C, expected_\\6Y_D, expected_\\6Y_E);
                $display("  Got:      \\6Y_A=%b, \\6Y_B=%b, \\6Y_C=%b, \\6Y_D=%b, \\6Y_E=%b",
                         \\6Y_A, \\6Y_B, \\6Y_C, \\6Y_D, \\6Y_E);
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
