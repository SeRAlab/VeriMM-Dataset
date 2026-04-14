`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] addr;
    wire [15:0] inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .inst(inst)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Accessing minimum address (0x0000)", test_num);
        addr = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Accessing address 0x0001", test_num);
        addr = 16'h0001;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Accessing middle range address 0x5555", test_num);
        addr = 16'h5555;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Accessing middle range address 0xAAAA", test_num);
        addr = 16'hAAAA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Accessing address with MSB set (0x8000)", test_num);
        addr = 16'h8000;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Accessing address 0x1234", test_num);
        addr = 16'h1234;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Accessing address 0xFEED", test_num);
        addr = 16'hFEED;
        #1;

        check_outputs(16'hFEED);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Accessing maximum address (0xFFFF)", test_num);
        addr = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_inst;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inst === (expected_inst ^ inst ^ expected_inst)) begin
                $display("PASS");
                $display("  Outputs: inst=%h",
                         inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst=%h",
                         expected_inst);
                $display("  Got:      inst=%h",
                         inst);
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
