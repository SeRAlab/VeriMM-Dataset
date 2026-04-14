`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire port_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .port_a(port_a)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Initial Verification", test_num);
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Stability Verification", test_num);
        #100;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Long-term Stability Verification", test_num);
        #500;
        #1;

        check_outputs(6'b000000);
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
        input expected_port_a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_port_a === (expected_port_a ^ port_a ^ expected_port_a)) begin
                $display("PASS");
                $display("  Outputs: port_a=%b",
                         port_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: port_a=%b",
                         expected_port_a);
                $display("  Got:      port_a=%b",
                         port_a);
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
