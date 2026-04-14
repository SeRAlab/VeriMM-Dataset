`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] signal_in;
    wire [63:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero input", test_num);
        signal_in = 32'h00000000;
        #1;

        check_outputs(64'h00000000_00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Minimum positive input", test_num);
        signal_in = 32'h00000001;
        #1;

        check_outputs(64'h00000000_00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Maximum 32-bit input", test_num);
        signal_in = 32'hFFFFFFFF;

        #1;


        check_outputs(64'h00000001_FFFFFFFE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary - MSB only", test_num);
        signal_in = 32'h80000000;

        #1;


        check_outputs(64'h00000001_00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Pattern 0x55555555", test_num);
        signal_in = 32'h55555555;

        #1;


        check_outputs(64'h00000000_AAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Pattern 0xAAAAAAAA", test_num);
        signal_in = 32'hAAAAAAAA;

        #1;


        check_outputs(64'h00000001_55555554);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Random value 1", test_num);
        signal_in = 32'h12345678;

        #1;


        check_outputs(64'h00000000_2468ACF0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Random value 2", test_num);
        signal_in = 32'hDEADBEEF;

        #1;


        check_outputs(64'h00000001_BD5B7DDE);
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
        input [63:0] expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
