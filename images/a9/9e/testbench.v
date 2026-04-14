`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    wire [31:0] eff_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .eff_addr(eff_addr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        addr = 32'h1ABCDEFF;
        $display("Test %0d: RAM Module Identification (Upper Nibble 0x1)", test_num);

        #1;


        check_outputs(32'h00ABCDEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        addr = 32'h00123456;
        $display("Test %0d: ROM Module Identification (Upper Nibble 0x0)", test_num);

        #1;


        check_outputs(32'h00023456);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        addr = 32'h2FFFFFFF;
        $display("Test %0d: UART Module Identification (Upper Nibble 0x2)", test_num);

        #1;


        check_outputs(32'h000FFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        addr = 32'h10000000;
        $display("Test %0d: RAM Module - Lower Boundary", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        addr = 32'hF5A5A5A5;
        $display("Test %0d: Other Module (Upper Nibble 0xF)", test_num);

        #1;


        check_outputs(32'h0005A5A5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        addr = 32'h00000000;
        $display("Test %0d: All Zeros Address", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        addr = 32'hFFFFFFFF;
        $display("Test %0d: All Ones Address", test_num);

        #1;


        check_outputs(32'h000FFFFF);
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
        input [31:0] expected_eff_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eff_addr === (expected_eff_addr ^ eff_addr ^ expected_eff_addr)) begin
                $display("PASS");
                $display("  Outputs: eff_addr=%h",
                         eff_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eff_addr=%h",
                         expected_eff_addr);
                $display("  Got:      eff_addr=%h",
                         eff_addr);
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
