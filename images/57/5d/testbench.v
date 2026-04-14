`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d;
    reg [32:0] x;
    wire q;
    wire [31:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .x(x),
        .q(q),
        .r(r)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x < d (Leading bit of x is 0)", test_num);
        x = 33'h0_0000_000A;
        d = 32'h0000_0014;
        #1;

        check_outputs(1'b0, 32'h0000_000A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x == d", test_num);
        x = 33'h0_0000_0014;
        d = 32'h0000_0014;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x > d (Leading bit of x is 0)", test_num);
        x = 33'h0_0000_0019;
        d = 32'h0000_0014;
        #1;

        check_outputs(1'b1, 32'h0000_0005);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x > d (Leading bit of x is 1, small d)", test_num);
        x = 33'h1_0000_0000;
        d = 32'h0000_0001;

        #1;


        check_outputs(1'b1, 32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x > d (Leading bit of x is 1, large d)", test_num);
        x = 33'h1_0000_0001;
        d = 32'hFFFF_FFFF;

        #1;


        check_outputs(1'b1, 32'h0000_0002);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: d is zero", test_num);
        x = 33'h0_0000_0005;
        d = 32'h0000_0000;

        #1;


        check_outputs(1'b1, 32'h0000_0005);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: x is zero", test_num);
        x = 33'h0_0000_0000;
        d = 32'h0000_000F;

        #1;


        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max values", test_num);
        x = 33'h1_FFFF_FFFF;
        d = 32'hFFFF_FFFF;

        #1;


        check_outputs(1'b1, 32'h0000_0000);
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
        input expected_q;
        input [31:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: q=%b, r=%h",
                         q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, r=%h",
                         expected_q, expected_r);
                $display("  Got:      q=%b, r=%h",
                         q, r);
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
