`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg last;
    reg [31:0] v_read;
    wire [31:0] ap_return_0;
    wire ap_return_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .last(last),
        .v_read(v_read),
        .ap_return_0(ap_return_0),
        .ap_return_1(ap_return_1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero value, last=0", test_num);
            v_read = 32'h00000000;
            last = 1'b0;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Float 1.0 representation, last=1", test_num);
            v_read = 32'h3F800000;
            last = 1'b1;
            #1;

            check_outputs(32'h3F800000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones pattern, last=0", test_num);
            v_read = 32'hFFFFFFFF;
            last = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random hex pattern, last=1", test_num);
            v_read = 32'hDEADBEEF;
            last = 1'b1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Infinity representation, last=0", test_num);
            v_read = 32'h7F800000;
            last = 1'b0;
            #1;

            check_outputs(32'h7F800000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits, last=1", test_num);
            v_read = 32'h55555555;
            last = 1'b1;
            #1;

            check_outputs(32'h55555555, 1'b1);
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
        input [31:0] expected_ap_return_0;
        input expected_ap_return_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ap_return_0 === (expected_ap_return_0 ^ ap_return_0 ^ expected_ap_return_0) &&
                expected_ap_return_1 === (expected_ap_return_1 ^ ap_return_1 ^ expected_ap_return_1)) begin
                $display("PASS");
                $display("  Outputs: ap_return_0=%h, ap_return_1=%b",
                         ap_return_0, ap_return_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ap_return_0=%h, ap_return_1=%b",
                         expected_ap_return_0, expected_ap_return_1);
                $display("  Got:      ap_return_0=%h, ap_return_1=%b",
                         ap_return_0, ap_return_1);
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
