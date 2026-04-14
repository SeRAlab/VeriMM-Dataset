`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [31:0] capabilities;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .capabilities(capabilities)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Capability Check", test_num);



            #1;




            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stability Verification", test_num);
            #100;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signal Integrity Check", test_num);
            #10;

            #1;


            check_outputs(32'h00000000);
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
        input [31:0] expected_capabilities;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_capabilities === (expected_capabilities ^ capabilities ^ expected_capabilities)) begin
                $display("PASS");
                $display("  Outputs: capabilities=%h",
                         capabilities);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: capabilities=%h",
                         expected_capabilities);
                $display("  Got:      capabilities=%h",
                         capabilities);
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
