`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] address;
    reg enable;
    wire bitline;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .enable(enable),
        .bitline(bitline)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable=0, Address=0", test_num);
        enable = 0;
        address = 2'b00;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable=0, Address=3", test_num);
        enable = 0;
        address = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable=1, Address=0", test_num);
        enable = 1;
        address = 2'b00;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable=1, Address=1", test_num);
        enable = 1;
        address = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable=1, Address=2", test_num);
        enable = 1;
        address = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable=1, Address=3", test_num);
        enable = 1;
        address = 2'b11;
        #1;

        check_outputs(4'b1000);
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
        input expected_bitline;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bitline === (expected_bitline ^ bitline ^ expected_bitline)) begin
                $display("PASS");
                $display("  Outputs: bitline=%b",
                         bitline);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bitline=%b",
                         expected_bitline);
                $display("  Got:      bitline=%b",
                         bitline);
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
