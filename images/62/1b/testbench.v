`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [90:0] wrap64_isSentry_cap;
    wire wrap64_isSentry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wrap64_isSentry_cap(wrap64_isSentry_cap),
        .wrap64_isSentry(wrap64_isSentry)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros input", test_num);
        wrap64_isSentry_cap = 91'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Match (Value 14) at target segment", test_num);
        wrap64_isSentry_cap = 91'b0;
        wrap64_isSentry_cap[36:33] = 4'b1110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Near match (Value 15) at target segment", test_num);
        wrap64_isSentry_cap = 91'b0;
        wrap64_isSentry_cap[36:33] = 4'b1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Near match (Value 6 / 0110) at target segment", test_num);
        wrap64_isSentry_cap = 91'b0;
        wrap64_isSentry_cap[36:33] = 4'b0110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Value 14 with all other bits set to 1", test_num);
        wrap64_isSentry_cap = {91{1'b1}};
        wrap64_isSentry_cap[36:33] = 4'b1110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Value 7 at target segment", test_num);
        wrap64_isSentry_cap = 91'b0;
        wrap64_isSentry_cap[36:33] = 4'b0111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Target is 0, bit 37 and 32 are 1", test_num);
        wrap64_isSentry_cap = 91'b0;
        wrap64_isSentry_cap[37] = 1'b1;
        wrap64_isSentry_cap[32] = 1'b1;
        #1;

        check_outputs(1'b0);
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
        input expected_wrap64_isSentry;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wrap64_isSentry === (expected_wrap64_isSentry ^ wrap64_isSentry ^ expected_wrap64_isSentry)) begin
                $display("PASS");
                $display("  Outputs: wrap64_isSentry=%b",
                         wrap64_isSentry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wrap64_isSentry=%b",
                         expected_wrap64_isSentry);
                $display("  Got:      wrap64_isSentry=%b",
                         wrap64_isSentry);
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
