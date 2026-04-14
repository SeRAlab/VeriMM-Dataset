`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire is_one_hot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .is_one_hot(is_one_hot)
    );
    task testcase001;

    begin
        $display("Testcase 001: All zeros (No bits set)");
        in = 10'b0000000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: LSB set (One-hot)");
        in = 10'b0000000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: MSB set (One-hot)");
        in = 10'b1000000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Middle bit set (One-hot)");
        in = 10'b0000100000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Two bits set (Not one-hot)");
        in = 10'b0000000011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Multiple bits set across vector (Not one-hot)");
        in = 10'b1010101010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: All bits set (Not one-hot)");
        in = 10'b1111111111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Neighboring bits set (Not one-hot)");
        in = 10'b0001100000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Highest and lowest bits set (Not one-hot)");
        in = 10'b1000000001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Bit 1 set (One-hot)");
        in = 10'b0000000010;
        #1;

        check_outputs(1'b1);
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
        testcase010();
        
        
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
        input expected_is_one_hot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_one_hot === (expected_is_one_hot ^ is_one_hot ^ expected_is_one_hot)) begin
                $display("PASS");
                $display("  Outputs: is_one_hot=%b",
                         is_one_hot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_one_hot=%b",
                         expected_is_one_hot);
                $display("  Got:      is_one_hot=%b",
                         is_one_hot);
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
