`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] i;
    wire [9:0] o0;
    wire [4:0] o1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o0(o0),
        .o1(o1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        i = 15'b000_0000_0000_0000;
        #1;

        check_outputs(10'h000, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        i = 15'b111_1111_1111_1111;
        #1;

        check_outputs(10'h3FF, 5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits 1010...", test_num);
        i = 15'h5555;

        #1;


        check_outputs(10'h155, 5'h15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits 0101...", test_num);
        i = 15'h2AAA;

        #1;


        check_outputs(10'h2AA, 5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Upper bits high, lower bits low", test_num);
        i = 15'b11111_0000000000;
        #1;

        check_outputs(10'h000, 5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Upper bits low, lower bits high", test_num);
        i = 15'b00000_1111111111;
        #1;

        check_outputs(10'h3FF, 5'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Pattern 1234", test_num);
        i = 15'h1234;

        #1;


        check_outputs(10'h234, 5'h04);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking 1 split boundary", test_num);
        i = 15'h0400;
        #1;

        check_outputs(10'h000, 5'h01);
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
        input [9:0] expected_o0;
        input [4:0] expected_o1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%h",
                         o0, o1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%h",
                         expected_o0, expected_o1);
                $display("  Got:      o0=%h, o1=%h",
                         o0, o1);
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
