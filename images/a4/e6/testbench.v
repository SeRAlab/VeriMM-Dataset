`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] imagPart;
    reg [11:0] realPart;
    wire [11:0] minimum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imagPart(imagPart),
        .realPart(realPart),
        .minimum(minimum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: imagPart < realPart", test_num);
        imagPart = 12'd10;
        realPart = 12'd50;
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: realPart < imagPart", test_num);
        imagPart = 12'd100;
        realPart = 12'd20;
        #1;

        check_outputs(12'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: imagPart == realPart", test_num);
        imagPart = 12'd255;
        realPart = 12'd255;
        #1;

        check_outputs(12'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero vs Max value", test_num);
        imagPart = 12'h000;
        realPart = 12'hFFF;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both max values", test_num);
        imagPart = 12'hFFF;
        realPart = 12'hFFF;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Near values (imagPart smaller)", test_num);
        imagPart = 12'd2047;
        realPart = 12'd2048;
        #1;

        check_outputs(12'd2047);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Near values (realPart smaller)", test_num);
        imagPart = 12'd2048;
        realPart = 12'd2047;
        #1;

        check_outputs(12'd2047);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern check", test_num);
        imagPart = 12'hABC;
        realPart = 12'hDEF;
        #1;

        check_outputs(12'hABC);
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
        input [11:0] expected_minimum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_minimum === (expected_minimum ^ minimum ^ expected_minimum)) begin
                $display("PASS");
                $display("  Outputs: minimum=%h",
                         minimum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: minimum=%h",
                         expected_minimum);
                $display("  Got:      minimum=%h",
                         minimum);
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
