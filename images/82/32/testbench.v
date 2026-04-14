`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] pkti;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pkti(pkti),
        .we(we)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits zero (Bits [9:8] = 00)", test_num);
        pkti = 10'b00_0000_0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Only bit 8 high (Bits [9:8] = 01)", test_num);
        pkti = 10'b01_0000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Only bit 9 high (Bits [9:8] = 10)", test_num);
        pkti = 10'b10_0000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both bits 9 and 8 high (Bits [9:8] = 11)", test_num);
        pkti = 10'b11_0000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower bits [7:0] high, but [9:8] = 00", test_num);
        pkti = 10'b00_1111_1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bit 9 high with lower bits high", test_num);
        pkti = 10'b10_1010_1010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bit 8 high with lower bits high", test_num);
        pkti = 10'b01_0101_0101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum value (all bits 1)", test_num);
        pkti = 10'b11_1111_1111;
        #1;

        check_outputs(1'b1);
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
        input expected_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: we=%b",
                         we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: we=%b",
                         expected_we);
                $display("  Got:      we=%b",
                         we);
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
