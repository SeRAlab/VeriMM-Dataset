`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] count;
    reg [3:0] ring;
    wire [3:0] digit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .ring(ring),
        .digit(digit)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        count = 16'h1234;
        ring  = 4'b0001;
        $display("Test %0d: Select segment 0 (count[3:0])", test_num);
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        count = 16'h1234;
        ring  = 4'b0010;
        $display("Test %0d: Select segment 1 (count[7:4])", test_num);
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        count = 16'h1234;
        ring  = 4'b0100;
        $display("Test %0d: Select segment 2 (count[11:8])", test_num);
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        count = 16'h1234;
        ring  = 4'b1000;
        $display("Test %0d: Select segment 3 (count[15:12])", test_num);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        count = 16'hFFFF;
        ring  = 4'b0010;
        $display("Test %0d: All bits high, select segment 1", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        count = 16'h0000;
        ring  = 4'b1000;
        $display("Test %0d: All bits low, select segment 3", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        count = 16'hA5C3;
        ring  = 4'b0100;
        $display("Test %0d: Pattern A5C3, select segment 2 (5)", test_num);
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        count = 16'hA5C3;
        ring  = 4'b0001;
        $display("Test %0d: Pattern A5C3, select segment 0 (3)", test_num);
        #1;

        check_outputs(4'h3);
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
        input [3:0] expected_digit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digit === (expected_digit ^ digit ^ expected_digit)) begin
                $display("PASS");
                $display("  Outputs: digit=%h",
                         digit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit=%h",
                         expected_digit);
                $display("  Got:      digit=%h",
                         digit);
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
