`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] D0;
    reg [10:0] D1;
    reg ctrl;
    wire [10:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .ctrl(ctrl),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 - Basic values", test_num);
            ctrl = 1'b0;
            D0 = 11'h2AA;
            D1 = 11'h555;
            #1;

            check_outputs(11'h2AA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 - Basic values", test_num);
            ctrl = 1'b1;
            D0 = 11'h2AA;
            D1 = 11'h555;
            #1;

            check_outputs(11'h555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 - All Zeros boundary", test_num);
            ctrl = 1'b0;
            D0 = 11'h000;
            D1 = 11'h7FF;
            #1;

            check_outputs(11'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 - All Ones boundary", test_num);
            ctrl = 1'b1;
            D0 = 11'h000;
            D1 = 11'h7FF;
            #1;

            check_outputs(11'h7FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 - Pattern check", test_num);
            ctrl = 1'b0;
            D0 = 11'h123;
            D1 = 11'h456;
            #1;

            check_outputs(11'h123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 - Bit transition check", test_num);
            ctrl = 1'b1;
            D0 = 11'h3FF;
            D1 = 11'h400;
            #1;

            check_outputs(11'h400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D0 - Random-style value", test_num);
            ctrl = 1'b0;
            D0 = 11'h5A5;
            D1 = 11'h25A;
            #1;

            check_outputs(11'h5A5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select D1 - Inverse pattern", test_num);
            ctrl = 1'b1;
            D0 = 11'h5A5;
            D1 = 11'h25A;
            #1;

            check_outputs(11'h25A);
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
        input [10:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
