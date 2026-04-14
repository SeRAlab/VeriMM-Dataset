`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] B_in;
    wire [2:0] A_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B_in(B_in),
        .A_out(A_out)
    );
    task testcase001;

    begin
        test_num = 1;
        B_in = 3'b000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        B_in = 3'b001;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        B_in = 3'b010;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        B_in = 3'b011;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        B_in = 3'b100;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        B_in = 3'b101;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        B_in = 3'b110;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        B_in = 3'b111;
        #1;

        check_outputs(3'b001);
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
        input [2:0] expected_A_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_out === (expected_A_out ^ A_out ^ expected_A_out)) begin
                $display("PASS");
                $display("  Outputs: A_out=%h",
                         A_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_out=%h",
                         expected_A_out);
                $display("  Got:      A_out=%h",
                         A_out);
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
