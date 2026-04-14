`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [3:0] priority_in;
    wire [1:0] priority_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .priority_in(priority_in),
        .priority_out(priority_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single bit active (Bit 0)", test_num);
        in = 32'h11223344;
        priority_in = 4'b0001;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single bit active (Bit 1)", test_num);
        in = 32'hAABBCCDD;
        priority_in = 4'b0010;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single bit active (Bit 2)", test_num);
        in = 32'hFFEEDDCC;
        priority_in = 4'b0100;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single bit active (Bit 3)", test_num);
        in = 32'h12345678;
        priority_in = 4'b1000;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple bits (3 and 0 active)", test_num);
        in = 32'h00000000;
        priority_in = 4'b1001;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple bits (2, 1, 0 active)", test_num);
        in = 32'hFFFFFFFF;
        priority_in = 4'b0111;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple bits (1 and 0 active)", test_num);
        in = 32'h55AA55AA;
        priority_in = 4'b0011;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All bits active", test_num);
        in = 32'h87654321;
        priority_in = 4'b1111;
        #1;

        check_outputs(2'd3);
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
        input [1:0] expected_priority_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_priority_out === (expected_priority_out ^ priority_out ^ expected_priority_out)) begin
                $display("PASS");
                $display("  Outputs: priority_out=%h",
                         priority_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: priority_out=%h",
                         expected_priority_out);
                $display("  Got:      priority_out=%h",
                         priority_out);
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
