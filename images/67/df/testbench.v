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
            $display("Test Case %0d: Initial Value Check", test_num);



            #1;




            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stability Check (10ns)", test_num);
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Long-term Consistency Check (100ns)", test_num);
            #90;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise Integrity Check", test_num);
            #5;
            if (^capabilities === 1'bX) begin
                $display("FAIL: Detected X or Z in capabilities: %h", capabilities);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: All bits are driven to valid logic levels.");
                pass_count = pass_count + 1;
            end
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
