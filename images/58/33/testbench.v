`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] binary;
    wire [1:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .binary(binary),
        .gray(gray)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            binary = 2'b00;
            $display("Test Case %0d: Binary input 00", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            binary = 2'b01;
            $display("Test Case %0d: Binary input 01", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            binary = 2'b10;
            $display("Test Case %0d: Binary input 10", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            binary = 2'b11;
            $display("Test Case %0d: Binary input 11", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [1:0] expected_gray;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
