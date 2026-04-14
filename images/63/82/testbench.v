`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] l;
    reg [9:0] m;
    wire [9:0] n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l(l),
        .m(m),
        .n(n)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        l = 10'd100;
        m = 10'd50;
        $display("Test %0d: l > m Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        l = 10'd250;
        m = 10'd800;
        $display("Test %0d: m > l Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd800);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        l = 10'd512;
        m = 10'd512;
        $display("Test %0d: Equal Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd512);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        l = 10'd0;
        m = 10'd1;
        $display("Test %0d: Minimum Value Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        l = 10'h3FF;
        m = 10'h3FE;
        $display("Test %0d: Maximum Value Case (l=%h, m=%h)", test_num, l, m);
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        l = 10'd777;
        m = 10'd778;
        $display("Test %0d: Close Proximity Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd778);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        l = 10'd0;
        m = 10'd0;
        $display("Test %0d: All Zeros Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        l = 10'd256;
        m = 10'd128;
        $display("Test %0d: Power of 2 Case (l=%0d, m=%0d)", test_num, l, m);
        #1;

        check_outputs(10'd256);
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
        input [9:0] expected_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: n=%h",
                         n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%h",
                         expected_n);
                $display("  Got:      n=%h",
                         n);
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
