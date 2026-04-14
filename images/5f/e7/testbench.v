`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [32:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        in1 = 32'h00000000;
        in2 = 32'h00000000;
        #1;

        check_outputs(33'h000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple addition without carry", test_num);
        in1 = 32'h12345678;
        in2 = 32'h11111111;
        #1;

        check_outputs(33'h023456789);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (No Carry Out)", test_num);
        in1 = 32'h55555555;
        in2 = 32'hAAAAAAAA;
        #1;

        check_outputs(33'h0FFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 32-bit value + 1 (Carry Out check)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'h00000001;
        #1;

        check_outputs(33'h100000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum sum (Two Max 32-bit values)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;
        #1;

        check_outputs(33'h1FFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry propagation across segment boundaries", test_num);


        in1 = 32'h000000FF;
        in2 = 32'h00000001;
        #1;

        check_outputs(33'h000000100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High-bit addition with carry", test_num);
        in1 = 32'h80000000;
        in2 = 32'h80000000;
        #1;

        check_outputs(33'h100000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern", test_num);
        in1 = 32'hA5A5A5A5;
        in2 = 32'h12344321;
        #1;

        check_outputs(33'h0B7D9E8C6);
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
        input [32:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
