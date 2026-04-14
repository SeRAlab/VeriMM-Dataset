`timescale 1ns/1ps

module portfolio_optimization_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] allocation_in;
    wire [4:0] allocation_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimization dut (
        .allocation_in(allocation_in),
        .allocation_out(allocation_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 0 (Minimum)", test_num);
        allocation_in = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 7 (Below limit)", test_num);
        allocation_in = 5'd7;
        #1;

        check_outputs(5'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 15 (At limit)", test_num);
        allocation_in = 5'd15;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 16 (Just above limit)", test_num);
        allocation_in = 5'd16;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 24 (Above limit)", test_num);
        allocation_in = 5'd24;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 31 (Maximum)", test_num);
        allocation_in = 5'd31;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 10 (Below limit)", test_num);
        allocation_in = 5'd10;
        #1;

        check_outputs(5'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimization Testbench");
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
        input [4:0] expected_allocation_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allocation_out === (expected_allocation_out ^ allocation_out ^ expected_allocation_out)) begin
                $display("PASS");
                $display("  Outputs: allocation_out=%h",
                         allocation_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocation_out=%h",
                         expected_allocation_out);
                $display("  Got:      allocation_out=%h",
                         allocation_out);
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
