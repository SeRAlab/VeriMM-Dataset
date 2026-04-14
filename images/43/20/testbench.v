`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] i;
    wire [63:0] rc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .rc(rc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros", test_num);
        i = 24'h000000;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Ones", test_num);
        i = 24'hFFFFFF;
        #1;

        check_outputs(64'h0558C04739265E64);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking One - Bit 0", test_num);
        i = 24'h000001;
        #1;

        check_outputs(64'h42F0E1EBA9EA3693);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking One - Bit 23", test_num);
        i = 24'h800000;
        #1;

        check_outputs(64'h98AB55C522B48D1E);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits (AAAAAA)", test_num);
        i = 24'hAAAAAA;
        #1;

        check_outputs(64'h7D7F9138B7C6E97E);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits (555555)", test_num);
        i = 24'h555555;
        #1;

        check_outputs(64'h7827517F8EE0B71A);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Data (123456)", test_num);
        i = 24'h123456;
        #1;

        check_outputs(64'hF034C03B520849E9);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower Byte Only", test_num);
        i = 24'h0000FF;
        #1;

        check_outputs(64'hBE04963578038755);
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
        input [63:0] expected_rc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rc === (expected_rc ^ rc ^ expected_rc)) begin
                $display("PASS");
                $display("  Outputs: rc=%h",
                         rc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rc=%h",
                         expected_rc);
                $display("  Got:      rc=%h",
                         rc);
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
