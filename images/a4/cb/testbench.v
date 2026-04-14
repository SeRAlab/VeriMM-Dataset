`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC4;
    reg [31:0] addr;
    wire [31:0] address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC4(PC4),
        .addr(addr),
        .address(address)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        PC4 = 32'h00000000;
        addr = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        PC4 = 32'hF0000000;
        addr = 32'h00000000;
        #1;

        check_outputs(32'hF0000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        PC4 = 32'h00000000;
        addr = 32'h03FFFFFF;
        #1;

        check_outputs(32'h0FFFFFFC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        PC4 = 32'h12345678;
        addr = 32'h00000001;
        #1;

        check_outputs(32'h10000004);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        PC4 = 32'hA0000000;
        addr = 32'h02AAAAAA;
        #1;

        check_outputs(32'hAAAAAAA8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        PC4 = 32'h00000000;
        addr = 32'h00000003;
        #1;

        check_outputs(32'h0000000C);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        PC4 = 32'h50000000;
        addr = 32'hFC000000;
        #1;

        check_outputs(32'h50000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        PC4 = 32'hFFFFFFFF;
        addr = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFC);
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
        input [31:0] expected_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address)) begin
                $display("PASS");
                $display("  Outputs: address=%h",
                         address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h",
                         expected_address);
                $display("  Got:      address=%h",
                         address);
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
