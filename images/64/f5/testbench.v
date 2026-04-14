`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en0;
    reg en1;
    reg in0;
    reg in1;
    wire [1:0] foo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en0(en0),
        .en1(en1),
        .in0(in0),
        .in1(in1),
        .foo(foo)
    );
    task reset_circuit;

        begin
            en0 = 1; in0 = 0;
            en1 = 1; in1 = 0;
            #5;
            en0 = 0; en1 = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state check");

            in0 = 0; en0 = 0; in1 = 0; en1 = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Set least significant bit (en0)");
            reset_circuit();
            in0 = 1; en0 = 1;
            in1 = 0; en1 = 0;
            #10;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Set most significant bit (en1)");
            reset_circuit();
            in0 = 0; en0 = 0;
            in1 = 1; en1 = 1;
            #10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Set both bits simultaneously");
            reset_circuit();
            in0 = 1; en0 = 1;
            in1 = 1; en1 = 1;
            #10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Hold value when enable is low");

            en0 = 1; in0 = 1; en1 = 1; in1 = 1;
            #10;

            en0 = 0; en1 = 0;
            in0 = 0; in1 = 0;
            #10;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Selective update (change LSB only)");

            en0 = 1; in0 = 1; en1 = 1; in1 = 1;
            #10;

            en0 = 1; in0 = 0;
            en1 = 0; in1 = 1;
            #10;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Selective update (change MSB only)");
            reset_circuit();

            en0 = 1; in0 = 1; en1 = 0; in1 = 0;
            #10;

            en0 = 0; in0 = 0;
            en1 = 1; in1 = 1;
            #10;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_foo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_foo === (expected_foo ^ foo ^ expected_foo)) begin
                $display("PASS");
                $display("  Outputs: foo=%h",
                         foo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: foo=%h",
                         expected_foo);
                $display("  Got:      foo=%h",
                         foo);
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
