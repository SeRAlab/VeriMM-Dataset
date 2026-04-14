`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in15;
    wire [31:0] extendido;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in15(in15),
        .extendido(extendido)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Positive zero", test_num);
        in15 = 9'h000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Small positive number", test_num);
        in15 = 9'h005;
        #1;

        check_outputs(32'h00000005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Maximum positive 9-bit number (bit 8 is 0)", test_num);
        in15 = 9'h0FF;
        #1;

        check_outputs(32'h000000FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Minimum negative 9-bit number (bit 8 is 1, in15=0x100)", test_num);
        in15 = 9'h100;
        #1;

        check_outputs(32'hFFFFFF00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Negative one (all bits 1)", test_num);
        in15 = 9'h1FF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Arbitrary negative number (0x155)", test_num);
        in15 = 9'h155;
        #1;

        check_outputs(32'hFFFFF155);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Arbitrary positive number (0x0AA)", test_num);
        in15 = 9'h0AA;
        #1;

        check_outputs(32'h000000AA);
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
        input [31:0] expected_extendido;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extendido === (expected_extendido ^ extendido ^ expected_extendido)) begin
                $display("PASS");
                $display("  Outputs: extendido=%h",
                         extendido);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extendido=%h",
                         expected_extendido);
                $display("  Got:      extendido=%h",
                         extendido);
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
