`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] in;
    reg s;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .s(s),
        .o(o)
    );
    task testcase001;

    begin
        $display("Testcase 001: s=0, in[0]=0, in[1]=0 -> o=0");
        in = 2'b00;
        s = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: s=0, in[0]=1, in[1]=0 -> o=1");
        in = 2'b01;
        s = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: s=0, in[0]=0, in[1]=1 -> o=0");
        in = 2'b10;
        s = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: s=0, in[0]=1, in[1]=1 -> o=1");
        in = 2'b11;
        s = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: s=1, in[0]=0, in[1]=0 -> o=0");
        in = 2'b00;
        s = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: s=1, in[0]=1, in[1]=0 -> o=0");
        in = 2'b01;
        s = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: s=1, in[0]=0, in[1]=1 -> o=1");
        in = 2'b10;
        s = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: s=1, in[0]=1, in[1]=1 -> o=1");
        in = 2'b11;
        s = 1;
        #1;

        check_outputs(1);
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
