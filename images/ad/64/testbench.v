`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] add_port_a;
    reg [31:0] add_port_b;
    wire [31:0] add_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_port_a(add_port_a),
        .add_port_b(add_port_b),
        .add_result(add_result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Adding Zeros", test_num);
        add_port_a = 32'h00000000;
        add_port_b = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Small Positive Integers", test_num);
        add_port_a = 32'd1234;
        add_port_b = 32'd5678;
        #1;

        check_outputs(32'd6912);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Identity Property", test_num);
        add_port_a = 32'hA5A5A5A5;
        add_port_b = 32'h00000000;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Maximum Unsigned Overflow", test_num);
        add_port_a = 32'hFFFFFFFF;
        add_port_b = 32'h00000001;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Hex Sum 1", test_num);
        add_port_a = 32'h12345678;
        add_port_b = 32'h87654321;
        #1;

        check_outputs(32'h99999999);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Carry Chain", test_num);
        add_port_a = 32'hFFFF0000;
        add_port_b = 32'h0000FFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Large Values Addition", test_num);
        add_port_a = 32'h7FFFFFFF;
        add_port_b = 32'h7FFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pattern Addition", test_num);
        add_port_a = 32'hAAAAAAAA;
        add_port_b = 32'h55555555;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_add_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_result === (expected_add_result ^ add_result ^ expected_add_result)) begin
                $display("PASS");
                $display("  Outputs: add_result=%h",
                         add_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_result=%h",
                         expected_add_result);
                $display("  Got:      add_result=%h",
                         add_result);
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
