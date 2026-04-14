`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Extsel;
    reg [15:0] immediate;
    wire [31:0] Eximmidiate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Extsel(Extsel),
        .immediate(immediate),
        .Eximmidiate(Eximmidiate)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Extsel=0, Positive Immediate", test_num);
        Extsel = 1'b0;
        immediate = 16'h1234;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Extsel=0, MSB=1 Immediate", test_num);
        Extsel = 1'b0;
        immediate = 16'h8005;
        #1;

        check_outputs(32'h00008005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Extsel=1, Positive Immediate", test_num);
        Extsel = 1'b1;
        immediate = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Extsel=1, Negative Immediate", test_num);
        Extsel = 1'b1;
        immediate = 16'h8000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Extsel=1, All ones Immediate", test_num);
        Extsel = 1'b1;
        immediate = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Extsel=0, All ones Immediate", test_num);
        Extsel = 1'b0;
        immediate = 16'hFFFF;
        #1;

        check_outputs(32'h0000FFFF);
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
        input [31:0] expected_Eximmidiate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Eximmidiate === (expected_Eximmidiate ^ Eximmidiate ^ expected_Eximmidiate)) begin
                $display("PASS");
                $display("  Outputs: Eximmidiate=%h",
                         Eximmidiate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Eximmidiate=%h",
                         expected_Eximmidiate);
                $display("  Got:      Eximmidiate=%h",
                         Eximmidiate);
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
