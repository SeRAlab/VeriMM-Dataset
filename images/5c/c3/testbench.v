`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] i;
    wire [7:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Input i=0", test_num);
        i = 5'd0;
        #1;

        check_outputs(8'h64);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Input i=5", test_num);
        i = 5'd5;
        #1;

        check_outputs(8'h69);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Input i=13", test_num);
        i = 5'd13;
        #1;

        check_outputs(8'h71);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Input i=14 (Default case)", test_num);
        i = 5'd14;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Input i=15", test_num);
        i = 5'd15;
        #1;

        check_outputs(8'h72);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Input i=16 (Default case)", test_num);
        i = 5'd16;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Input i=31 (Default case)", test_num);
        i = 5'd31;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
