`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros", test_num);
        a = 32'h00000000;
        b = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All Ones", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: No overlap (Alternating bits)", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Partial overlap (High vs Low)", test_num);
        a = 32'hFFFF0000;
        b = 32'h0000FFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Full overlap (Specific Nibbles)", test_num);
        a = 32'hF0F0F0F0;
        b = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hF0F0F0F0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Random pattern bitwise check", test_num);
        a = 32'h12345678;
        b = 32'h87654321;





        #1;






        check_outputs(32'h02244220);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: One input Zero", test_num);
        a = 32'hABCDEF01;
        b = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Walking bit test", test_num);
        a = 32'h80000000;
        b = 32'h80000000;
        #1;

        check_outputs(32'h80000000);
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
        input [31:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
