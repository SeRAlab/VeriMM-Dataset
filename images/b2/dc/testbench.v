`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg [1:0] y;
    reg z;
    wire [1:0] A;
    wire [2:0] B;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z),
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        x = 0; y = 0; z = 0;
        `ifdef BUG
            #1;

            check_outputs(0 + 0, 0 * 0, 0 - 0 - 0);
        `else
            #1;

            check_outputs({1'b0, 1'b0}, {1'b0, 2'b00}, {1'b0, 2'b00, 1'b0});
        `endif
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=1, y=0, z=0", test_num);
        x = 1; y = 0; z = 0;
        `ifdef BUG
            #1;

            check_outputs(1 + 0, 1 * 0, 1 - 0 - 0);
        `else
            #1;

            check_outputs({1'b1, 1'b0}, {1'b1, 2'b00}, {1'b1, 2'b00, 1'b0});
        `endif
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=0, y=1, z=0", test_num);
        x = 0; y = 1; z = 0;
        `ifdef BUG
            #1;

            check_outputs(0 + 0, 0 * 1, 0 - 1 - 0);
        `else
            #1;

            check_outputs({1'b0, 1'b0}, {1'b0, 2'b01}, {1'b0, 2'b01, 1'b0});
        `endif
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=0, y=0, z=1", test_num);
        x = 0; y = 0; z = 1;
        `ifdef BUG
            #1;

            check_outputs(0 + 1, 0 * 0, 0 - 0 - 1);
        `else
            #1;

            check_outputs({1'b0, 1'b1}, {1'b0, 2'b00}, {1'b0, 2'b00, 1'b1});
        `endif
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=1, y=2, z=0", test_num);
        x = 1; y = 2; z = 0;
        `ifdef BUG
            #1;

            check_outputs(1 + 0, 1 * 2, 1 - 2 - 0);
        `else
            #1;

            check_outputs({1'b1, 1'b0}, {1'b1, 2'b10}, {1'b1, 2'b10, 1'b0});
        `endif
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=0, y=3, z=1", test_num);
        x = 0; y = 3; z = 1;
        `ifdef BUG
            #1;

            check_outputs(0 + 1, 0 * 3, 0 - 3 - 1);
        `else
            #1;

            check_outputs({1'b0, 1'b1}, {1'b0, 2'b11}, {1'b0, 2'b11, 1'b1});
        `endif
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=1, y=3, z=1 (Max Inputs)", test_num);
        x = 1; y = 3; z = 1;
        `ifdef BUG
            #1;

            check_outputs(1 + 1, 1 * 3, 1 - 3 - 1);
        `else
            #1;

            check_outputs({1'b1, 1'b1}, {1'b1, 2'b11}, {1'b1, 2'b11, 1'b1});
        `endif
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x=1, y=1, z=1", test_num);
        x = 1; y = 1; z = 1;
        `ifdef BUG
            #1;

            check_outputs(1 + 1, 1 * 1, 1 - 1 - 1);
        `else
            #1;

            check_outputs({1'b1, 1'b1}, {1'b1, 2'b01}, {1'b1, 2'b01, 1'b1});
        `endif
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
        input [1:0] expected_A;
        input [2:0] expected_B;
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h, C=%h",
                         A, B, C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h, C=%h",
                         expected_A, expected_B, expected_C);
                $display("  Got:      A=%h, B=%h, C=%h",
                         A, B, C);
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
