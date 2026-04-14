`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IorD;
    reg [15:0] SP;
    wire [15:0] newSP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IorD(IorD),
        .SP(SP),
        .newSP(newSP)
    );
    task testcase001;

    begin
        test_num = 1;
        IorD = 1'b0;
        SP = 16'h0000;

        #1;


        check_outputs(16'h0004);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        IorD = 1'b1;
        SP = 16'h0004;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        IorD = 1'b0;
        SP = 16'h0FFC;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        IorD = 1'b1;
        SP = 16'h2000;

        #1;


        check_outputs(16'h2FFC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        IorD = 1'b0;
        SP = 16'hF000;

        #1;


        check_outputs(16'hF004);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        IorD = 1'b0;
        SP = 16'h1237;

        #1;


        check_outputs(16'h1238);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        IorD = 1'b1;
        SP = 16'hABCD;

        #1;


        check_outputs(16'hABC8);
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
        input [15:0] expected_newSP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_newSP === (expected_newSP ^ newSP ^ expected_newSP)) begin
                $display("PASS");
                $display("  Outputs: newSP=%h",
                         newSP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: newSP=%h",
                         expected_newSP);
                $display("  Got:      newSP=%h",
                         newSP);
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
