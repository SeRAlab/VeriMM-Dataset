`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] SW;
    wire [9:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .LEDR(LEDR)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All switches OFF (0x000)", test_num);
        SW = 10'b00_0000_0000;
        #1;

        check_outputs(10'b00_0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All switches ON (0x3FF)", test_num);
        SW = 10'b11_1111_1111;
        #1;

        check_outputs(10'b11_1111_1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating pattern A (0x2AA)", test_num);
        SW = 10'b10_1010_1010;
        #1;

        check_outputs(10'b10_1010_1010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating pattern B (0x155)", test_num);
        SW = 10'b01_0101_0101;
        #1;

        check_outputs(10'b01_0101_0101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hex pattern 0x123", test_num);
        SW = 10'h123;
        #1;

        check_outputs(10'h123);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Individual bit check (MSB)", test_num);
        SW = 10'b10_0000_0000;
        #1;

        check_outputs(10'b10_0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Individual bit check (LSB)", test_num);
        SW = 10'b00_0000_0001;
        #1;

        check_outputs(10'b00_0000_0001);
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
        input [9:0] expected_LEDR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
