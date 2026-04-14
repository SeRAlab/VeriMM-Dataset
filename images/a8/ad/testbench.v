`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] b;
    wire [9:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .p(p)
    );
    task testcase001;

    begin
        test_num = 1;
        b = 8'd0;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        b = 8'd5;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        b = 8'd9;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h009);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        b = 8'd10;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        b = 8'd42;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h042);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        b = 8'd99;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h099);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        b = 8'd100;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        b = 8'd123;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h123);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        b = 8'd200;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h200);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        b = 8'd255;
        $display("Test Case %0d: Input b = %d", test_num, b);
        #1;

        check_outputs(10'h255);
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
        testcase009();
        testcase010();
        
        
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
        input [9:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
