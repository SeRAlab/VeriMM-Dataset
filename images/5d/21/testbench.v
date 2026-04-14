`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] b;
    wire [5:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .c(c)
    );
    task testcase001;

        begin
            test_num = 1;
            b = 6'b000000;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            b = 6'b111111;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            b = 6'b101010;
            #1;

            check_outputs(6'b010101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            b = 6'b010101;
            #1;

            check_outputs(6'b101010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            b = 6'b110011;
            #1;

            check_outputs(6'b001100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            b = 6'b000111;
            #1;

            check_outputs(6'b111000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            b = 6'b100001;
            #1;

            check_outputs(6'b011110);
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
        input [5:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
