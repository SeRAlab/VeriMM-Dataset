`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] D0;
    reg [10:0] D1;
    reg [10:0] D2;
    reg [1:0] ctrl;
    wire [10:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .ctrl(ctrl),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select D0 (ctrl=00)", test_num);
            D0 = 11'h123;
            D1 = 11'h456;
            D2 = 11'h789;
            ctrl = 2'b00;
            #1;

            check_outputs(11'h123);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select D1 (ctrl=01)", test_num);
            D0 = 11'h123;
            D1 = 11'h456;
            D2 = 11'h789;
            ctrl = 2'b01;
            #1;

            check_outputs(11'h456);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select D2 (ctrl=10)", test_num);
            D0 = 11'h123;
            D1 = 11'h456;
            D2 = 11'h789;
            ctrl = 2'b10;
            #1;

            check_outputs(11'h789);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Undefined ctrl (ctrl=11) - Default to Zero", test_num);
            D0 = 11'h7FF;
            D1 = 11'h7FF;
            D2 = 11'h7FF;
            ctrl = 2'b11;
            #1;

            check_outputs(11'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select D0 with all bits high", test_num);
            D0 = 11'h7FF;
            D1 = 11'h000;
            D2 = 11'h000;
            ctrl = 2'b00;
            #1;

            check_outputs(11'h7FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select D1 with alternating bits", test_num);
            D0 = 11'h000;
            D1 = 11'h555;
            D2 = 11'hAAA;
            ctrl = 2'b01;
            #1;

            check_outputs(11'h555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select D2 with alternating bits", test_num);
            D0 = 11'h000;
            D1 = 11'h555;
            D2 = 11'hAAA;
            ctrl = 2'b10;
            #1;

            check_outputs(11'hAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Zero inputs check", test_num);
            D0 = 11'h000;
            D1 = 11'h000;
            D2 = 11'h000;
            ctrl = 2'b00;
            #1;

            check_outputs(11'h000);
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
