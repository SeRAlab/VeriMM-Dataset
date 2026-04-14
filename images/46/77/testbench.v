`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d_i;
    wire [31:0] d_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_i(d_i),
        .d_o(d_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment zero", test_num);
            d_i = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment standard value", test_num);
            d_i = 32'h0000_0064;
            #1;

            check_outputs(32'h0000_0068);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary value - Wrap to zero", test_num);
            d_i = 32'hFFFF_FFFC;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value wrap around", test_num);
            d_i = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large value check", test_num);
            d_i = 32'h1234_5678;
            #1;

            check_outputs(32'h1234_567C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign bit transition check", test_num);
            d_i = 32'h7FFF_FFFD;
            #1;

            check_outputs(32'h8000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Another wrap around", test_num);
            d_i = 32'hFFFF_FFFE;
            #1;

            check_outputs(32'h0000_0002);
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
        input [31:0] expected_d_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_o === (expected_d_o ^ d_o ^ expected_d_o)) begin
                $display("PASS");
                $display("  Outputs: d_o=%h",
                         d_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_o=%h",
                         expected_d_o);
                $display("  Got:      d_o=%h",
                         d_o);
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
