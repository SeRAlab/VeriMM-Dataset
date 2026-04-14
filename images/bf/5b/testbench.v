`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg byte_access;
    reg hw;
    reg [25:0] write_address;
    wire [1:0] write_byteenable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byte_access(byte_access),
        .hw(hw),
        .write_address(write_address),
        .write_byteenable(write_byteenable)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Byte Access enabled, HW disabled, Address LSB = 0 (Lower Byte)", test_num);
            byte_access = 1'b1;
            hw = 1'b0;
            write_address = 26'h0000000;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Byte Access enabled, HW disabled, Address LSB = 1 (Upper Byte)", test_num);
            byte_access = 1'b1;
            hw = 1'b0;
            write_address = 26'h0000001;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Byte Access enabled, HW enabled (Half-word access), Address LSB = 0", test_num);
            byte_access = 1'b1;
            hw = 1'b1;
            write_address = 26'h0000000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Byte Access enabled, HW enabled (Half-word access), Address LSB = 1", test_num);
            byte_access = 1'b1;
            hw = 1'b1;
            write_address = 26'h0000001;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Byte Access disabled, Address LSB = 0 (Default full word access)", test_num);
            byte_access = 1'b0;
            hw = 1'b0;
            write_address = 26'h0000000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Byte Access disabled, Address LSB = 1 (Default full word access)", test_num);
            byte_access = 1'b0;
            hw = 1'b1;
            write_address = 26'h0000001;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Byte Access enabled, HW disabled, High bits in address, LSB = 0", test_num);
            byte_access = 1'b1;
            hw = 1'b0;
            write_address = 26'h3FFFFFE;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Byte Access enabled, HW disabled, High bits in address, LSB = 1", test_num);
            byte_access = 1'b1;
            hw = 1'b0;
            write_address = 26'h1ABCDEF;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_write_byteenable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_write_byteenable === (expected_write_byteenable ^ write_byteenable ^ expected_write_byteenable)) begin
                $display("PASS");
                $display("  Outputs: write_byteenable=%h",
                         write_byteenable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: write_byteenable=%h",
                         expected_write_byteenable);
                $display("  Got:      write_byteenable=%h",
                         write_byteenable);
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
