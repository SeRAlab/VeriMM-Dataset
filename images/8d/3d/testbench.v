`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] Q;
    wire [2:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .d(d)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Q = 000 (Expect d[2]=1)", test_num);
        Q = 3'b000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Q = 001 (Expect d[0]=1)", test_num);
        Q = 3'b001;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Q = 010 (Expect d[1]=1)", test_num);
        Q = 3'b010;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Q = 011 (Expect d=000)", test_num);
        Q = 3'b011;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Q = 100 (Expect d=000)", test_num);
        Q = 3'b100;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Q = 101 (Expect d=000)", test_num);
        Q = 3'b101;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Q = 110 (Expect d=000)", test_num);
        Q = 3'b110;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Q = 111 (Expect d=000)", test_num);
        Q = 3'b111;
        #1;

        check_outputs(3'b000);
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
        input [2:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
