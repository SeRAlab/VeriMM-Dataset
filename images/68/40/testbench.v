`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ExtSel;
    reg [15:0] ime;
    wire [31:0] exten;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ExtSel(ExtSel),
        .ime(ime),
        .exten(exten)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: ExtSel=1, MSB=1 (Expect Sign Extension)", test_num);
        ExtSel = 1'b1;
        ime = 16'h8005;
        #1;

        check_outputs(32'hFFFF8005);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: ExtSel=1, MSB=0 (Expect Zero Extension)", test_num);
        ExtSel = 1'b1;
        ime = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: ExtSel=0, MSB=1 (Expect Zero Extension)", test_num);
        ExtSel = 1'b0;
        ime = 16'hA000;
        #1;

        check_outputs(32'h0000A000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: ExtSel=0, MSB=0 (Expect Zero Extension)", test_num);
        ExtSel = 1'b0;
        ime = 16'h1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: ExtSel=1, ime=FFFF (Expect All Ones)", test_num);
        ExtSel = 1'b1;
        ime = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: ExtSel=1, ime=0000 (Expect All Zeros)", test_num);
        ExtSel = 1'b1;
        ime = 16'h0000;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_exten;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exten === (expected_exten ^ exten ^ expected_exten)) begin
                $display("PASS");
                $display("  Outputs: exten=%h",
                         exten);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exten=%h",
                         expected_exten);
                $display("  Got:      exten=%h",
                         exten);
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
