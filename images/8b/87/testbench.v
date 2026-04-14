`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inData;
    wire [31:0] outData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inData(inData),
        .outData(outData)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros", test_num);
        inData = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Small value (1)", test_num);
        inData = 32'h0000_0001;
        #1;

        check_outputs(32'h0000_0004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Maximum 32-bit value (Truncation check)", test_num);
        inData = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'hFFFF_FFFC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Shifting bit 31 out (Overflow check)", test_num);
        inData = 32'h8000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Shifting bit 30 out (Overflow check)", test_num);
        inData = 32'h4000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Shifting bit 29 to bit 31", test_num);
        inData = 32'h2000_0000;
        #1;

        check_outputs(32'h8000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating pattern AAAA_AAAA", test_num);
        inData = 32'hAAAA_AAAA;
        #1;

        check_outputs(32'hAAAA_AAA8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating pattern 5555_5555", test_num);
        inData = 32'h5555_5555;
        #1;

        check_outputs(32'h5555_5554);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Complex bit pattern 0x12345678", test_num);
        inData = 32'h1234_5678;
        #1;

        check_outputs(32'h48D1_59E0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Complex bit pattern 0xDEADBEEF", test_num);
        inData = 32'hDEAD_BEEF;
        #1;

        check_outputs(32'h7ABA_FBBC);
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
        input [31:0] expected_outData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outData === (expected_outData ^ outData ^ expected_outData)) begin
                $display("PASS");
                $display("  Outputs: outData=%h",
                         outData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outData=%h",
                         expected_outData);
                $display("  Got:      outData=%h",
                         outData);
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
