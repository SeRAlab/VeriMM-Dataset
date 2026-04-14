`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    wire [2:0] and_output;
    wire [2:0] twos_comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .and_output(and_output),
        .twos_comp(twos_comp)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b000", test_num);
        a = 3'b000;
        #1;

        check_outputs(3'b000, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b001", test_num);
        a = 3'b001;
        #1;

        check_outputs(3'b001, 3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b010", test_num);
        a = 3'b010;
        #1;

        check_outputs(3'b000, 3'b110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b011", test_num);
        a = 3'b011;
        #1;

        check_outputs(3'b001, 3'b101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b100", test_num);
        a = 3'b100;
        #1;

        check_outputs(3'b100, 3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b101", test_num);
        a = 3'b101;
        #1;

        check_outputs(3'b101, 3'b011);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b110", test_num);
        a = 3'b110;
        #1;

        check_outputs(3'b100, 3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a = 3'b111", test_num);
        a = 3'b111;
        #1;

        check_outputs(3'b101, 3'b001);
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
        input [2:0] expected_and_output;
        input [2:0] expected_twos_comp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_output === (expected_and_output ^ and_output ^ expected_and_output) &&
                expected_twos_comp === (expected_twos_comp ^ twos_comp ^ expected_twos_comp)) begin
                $display("PASS");
                $display("  Outputs: and_output=%h, twos_comp=%h",
                         and_output, twos_comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_output=%h, twos_comp=%h",
                         expected_and_output, expected_twos_comp);
                $display("  Got:      and_output=%h, twos_comp=%h",
                         and_output, twos_comp);
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
