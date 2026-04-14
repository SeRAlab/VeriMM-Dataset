`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] address_i;
    wire [4:0] q_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_i(address_i),
        .q_o(q_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("testcase001: Address 0 (Below Range)");
        address_i = 6'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("testcase002: Address 15 (Boundary Below Range)");
        address_i = 6'd15;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("testcase003: Address 16 (Start of Range Boundary)");
        address_i = 6'd16;
        #1;

        check_outputs(5'd27);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("testcase004: Address 32 (Mid-Range Sample)");
        address_i = 6'd32;
        #1;

        check_outputs(5'd24);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("testcase005: Address 51 (End of Range Boundary)");
        address_i = 6'd51;
        #1;

        check_outputs(5'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("testcase006: Address 52 (Boundary Above Range)");
        address_i = 6'd52;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("testcase007: Address 63 (Max Possible Address)");
        address_i = 6'd63;
        #1;

        check_outputs(5'd0);
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
        input [4:0] expected_q_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q_o === (expected_q_o ^ q_o ^ expected_q_o)) begin
                $display("PASS");
                $display("  Outputs: q_o=%h",
                         q_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_o=%h",
                         expected_q_o);
                $display("  Got:      q_o=%h",
                         q_o);
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
