`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] sw;
    wire [3:0] ld;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sw(sw),
        .ld(ld)
    );
    task testcase001;

    begin
        $display("Testcase 001: Input sw[0] (Digit 0)");
        test_num = test_num + 1;
        sw = 10'b0000000001;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Input sw[1] (Digit 1)");
        test_num = test_num + 1;
        sw = 10'b0000000010;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Input sw[2] (Digit 2)");
        test_num = test_num + 1;
        sw = 10'b0000000100;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Input sw[3] (Digit 3)");
        test_num = test_num + 1;
        sw = 10'b0000001000;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Input sw[4] (Digit 4)");
        test_num = test_num + 1;
        sw = 10'b0000010000;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Input sw[5] (Digit 5)");
        test_num = test_num + 1;
        sw = 10'b0000100000;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Input sw[6] (Digit 6)");
        test_num = test_num + 1;
        sw = 10'b0001000000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Input sw[7] (Digit 7)");
        test_num = test_num + 1;
        sw = 10'b0010000000;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Input sw[8] (Digit 8)");
        test_num = test_num + 1;
        sw = 10'b0100000000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Input sw[9] (Digit 9)");
        test_num = test_num + 1;
        sw = 10'b1000000000;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Multiple inputs (sw[1] and sw[8])");
        test_num = test_num + 1;
        sw = 10'b0100000010;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase012;

    begin
        $display("Testcase 012: No switches active");
        test_num = test_num + 1;
        sw = 10'b0000000000;
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_ld;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ld === (expected_ld ^ ld ^ expected_ld)) begin
                $display("PASS");
                $display("  Outputs: ld=%h",
                         ld);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ld=%h",
                         expected_ld);
                $display("  Got:      ld=%h",
                         ld);
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
