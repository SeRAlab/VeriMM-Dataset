`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] iaddr;
    wire [15:0] idata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iaddr(iaddr),
        .idata(idata)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0x0000", test_num);
        iaddr = 16'h0000;

        #1;


        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0x0001", test_num);
        iaddr = 16'h0001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0x0002", test_num);
        iaddr = 16'h0002;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0x0003", test_num);
        iaddr = 16'h0003;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0xFFFF (Out of range)", test_num);
        iaddr = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0x1234 (Out of range)", test_num);
        iaddr = 16'h1234;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Address 0x0010 (Assumed out of range)", test_num);
        iaddr = 16'h0010;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_idata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_idata === (expected_idata ^ idata ^ expected_idata)) begin
                $display("PASS");
                $display("  Outputs: idata=%h",
                         idata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: idata=%h",
                         expected_idata);
                $display("  Got:      idata=%h",
                         idata);
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
