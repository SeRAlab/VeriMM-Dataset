`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] count;
    reg s;
    reg [4:0] sk;
    wire [4:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .s(s),
        .sk(sk),
        .addr(addr)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select 'sk' (s=0)", test_num);
        s = 1'b0;
        count = 5'h0A;
        sk = 5'h15;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select 'count' (s=1)", test_num);
        s = 1'b1;
        count = 5'h0A;
        sk = 5'h15;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Boundary condition - all zeros on sk (s=0)", test_num);
        s = 1'b0;
        count = 5'h1F;
        sk = 5'h00;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Boundary condition - all ones on count (s=1)", test_num);
        s = 1'b1;
        count = 5'h1F;
        sk = 5'h00;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Alternating bits check (s=0)", test_num);
        s = 1'b0;
        count = 5'b10101;
        sk = 5'b01010;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Alternating bits check (s=1)", test_num);
        s = 1'b1;
        count = 5'b10101;
        sk = 5'b01010;
        #1;

        check_outputs(5'b10101);
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
        input [4:0] expected_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
