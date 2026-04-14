`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [31:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .checksum(checksum)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 4'b0000;
            $display("\nTestcase %0d: All Zeros (data=0000)", test_num);







            #1;








            check_outputs(32'hFFFFFFF1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 4'b1111;
            $display("\nTestcase %0d: All Ones (data=1111)", test_num);
            #1;

            check_outputs(32'hFFFFFFF1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 4'b0001;
            $display("\nTestcase %0d: Single Bit LSB (data=0001)", test_num);
            #1;

            check_outputs(32'hFFFFFFF1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 4'b1000;
            $display("\nTestcase %0d: Single Bit MSB (data=1000)", test_num);
            #1;

            check_outputs(32'hFFFFFFF1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 4'b1010;
            $display("\nTestcase %0d: Alternating Pattern 1010", test_num);
            #1;

            check_outputs(32'hFFFFFFF1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 4'b0101;
            $display("\nTestcase %0d: Alternating Pattern 0101", test_num);
            #1;

            check_outputs(32'hFFFFFFF1);
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
        input [31:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
