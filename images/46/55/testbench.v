`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    wire [5:0] out_add;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_add(out_add)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition (0 + 0)", test_num);
            a = 5'd0;
            b = 5'd0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values (31 + 31)", test_num);
            a = 5'd31;
            b = 5'd31;
            #1;

            check_outputs(6'd62);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small values (1 + 1)", test_num);
            a = 5'd1;
            b = 5'd1;
            #1;

            check_outputs(6'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry into bit 5 (16 + 16)", test_num);
            a = 5'd16;
            b = 5'd16;
            #1;

            check_outputs(6'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry from bit 4 (31 + 1)", test_num);
            a = 5'd31;
            b = 5'd1;
            #1;

            check_outputs(6'd32);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary addition (10 + 20)", test_num);
            a = 5'd10;
            b = 5'd20;
            #1;

            check_outputs(6'd30);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary addition (25 + 10)", test_num);
            a = 5'd25;
            b = 5'd10;
            #1;

            check_outputs(6'd35);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (21 + 10)", test_num);
            a = 5'b10101;
            b = 5'b01010;
            #1;

            check_outputs(6'd31);
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
        input [5:0] expected_out_add;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_add === (expected_out_add ^ out_add ^ expected_out_add)) begin
                $display("PASS");
                $display("  Outputs: out_add=%h",
                         out_add);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_add=%h",
                         expected_out_add);
                $display("  Got:      out_add=%h",
                         out_add);
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
