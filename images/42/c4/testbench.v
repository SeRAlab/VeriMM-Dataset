`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg byte_access;
    reg hw;
    reg word;
    reg [10:0] write_address;
    wire [3:0] write_byteenable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byte_access(byte_access),
        .hw(hw),
        .word(word),
        .write_address(write_address),
        .write_byteenable(write_byteenable)
    );
    task testcase001;

        begin
            test_num = 1;
            word = 1'b1;
            hw = 1'b0;
            byte_access = 1'b0;
            write_address = 11'h000;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            word = 1'b1;
            hw = 1'b0;
            byte_access = 1'b0;
            write_address = 11'h004;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            word = 1'b0;
            hw = 1'b1;
            byte_access = 1'b0;
            write_address = 11'h000;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            word = 1'b0;
            hw = 1'b1;
            byte_access = 1'b0;
            write_address = 11'h002;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            word = 1'b0;
            hw = 1'b0;
            byte_access = 1'b1;
            write_address = 11'h000;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            word = 1'b0;
            hw = 1'b0;
            byte_access = 1'b1;
            write_address = 11'h001;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            word = 1'b0;
            hw = 1'b0;
            byte_access = 1'b1;
            write_address = 11'h002;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            word = 1'b0;
            hw = 1'b0;
            byte_access = 1'b1;
            write_address = 11'h003;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            word = 1'b0;
            hw = 1'b0;
            byte_access = 1'b0;
            write_address = 11'h000;
            #1;

            check_outputs(4'b0000);
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
        testcase009();
        
        
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
        input [3:0] expected_write_byteenable;
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
