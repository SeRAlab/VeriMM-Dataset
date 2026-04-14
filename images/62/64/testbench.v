`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] a;
    wire [47:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input = 0");
        a = 48'h000000000000;
        #1;

        check_outputs(48'h000000000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input = 1");
        a = 48'h000000000001;
        #1;

        check_outputs(48'h000000000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Carry propagation (Low Byte)");
        a = 48'h0000000000FF;
        #1;

        check_outputs(48'h000000000100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Carry propagation (32 bits)");
        a = 48'h0000FFFFFFFF;
        #1;

        check_outputs(48'h000100000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Maximum value (Wrap around)");
        a = 48'hFFFFFFFFFFFF;
        #1;

        check_outputs(48'h000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Pattern AAAA_AAAA_AAAA");
        a = 48'hAAAAAAAAAAAAAAAA;
        #1;

        check_outputs(48'hAAAAAAAAAAAB);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Pattern FFFF_FFFF_FFFE");
        a = 48'hFFFFFFFFFFFE;
        #1;

        check_outputs(48'hFFFFFFFFFFFF);
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
        input [47:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
