`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inAddr;
    wire [31:0] outAddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inAddr(inAddr),
        .outAddr(outAddr)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero address", test_num);
        inAddr = 32'h00000000;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Typical memory address", test_num);
        inAddr = 32'h00001000;
        #1;

        check_outputs(32'h00001004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Large address", test_num);
        inAddr = 32'hA000BC00;
        #1;

        check_outputs(32'hA000BC04);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary address near overflow", test_num);
        inAddr = 32'hFFFFFFFC;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum 32-bit value overflow", test_num);
        inAddr = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bit pattern check", test_num);
        inAddr = 32'h12345678;
        #1;

        check_outputs(32'h1234567C);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating bit pattern", test_num);
        inAddr = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAAE);
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
        input [31:0] expected_outAddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outAddr === (expected_outAddr ^ outAddr ^ expected_outAddr)) begin
                $display("PASS");
                $display("  Outputs: outAddr=%h",
                         outAddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outAddr=%h",
                         expected_outAddr);
                $display("  Got:      outAddr=%h",
                         outAddr);
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
