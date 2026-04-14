`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] i;
    wire [3:0] lower_nibble;
    wire [3:0] upper_nibble;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .lower_nibble(lower_nibble),
        .upper_nibble(upper_nibble)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros", test_num);
        i = 9'b0_0000_0000;
        #5;

        #1;


        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All Ones", test_num);
        i = 9'b1_1111_1111;
        #5;

        #1;


        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Pattern A5 (Lower A, Upper 5)", test_num);



        i = 9'h0AA;
        #5;
        #1;

        check_outputs(4'hA, 4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Pattern 5A (Lower 5, Upper A)", test_num);



        i = 9'h155;
        #5;
        #1;

        check_outputs(4'h5, 4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Middle Bit and Boundaries", test_num);




        i = 9'h0F0;
        #5;
        #1;

        check_outputs(4'h0, 4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: MSB Check", test_num);



        i = 9'h10F;
        #5;
        #1;

        check_outputs(4'hF, 4'h8);
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
        input [3:0] expected_lower_nibble;
        input [3:0] expected_upper_nibble;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lower_nibble === (expected_lower_nibble ^ lower_nibble ^ expected_lower_nibble) &&
                expected_upper_nibble === (expected_upper_nibble ^ upper_nibble ^ expected_upper_nibble)) begin
                $display("PASS");
                $display("  Outputs: lower_nibble=%h, upper_nibble=%h",
                         lower_nibble, upper_nibble);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_nibble=%h, upper_nibble=%h",
                         expected_lower_nibble, expected_upper_nibble);
                $display("  Got:      lower_nibble=%h, upper_nibble=%h",
                         lower_nibble, upper_nibble);
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
