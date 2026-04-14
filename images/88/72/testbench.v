`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] line_number;
    wire [7:0] line_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .line_number(line_number),
        .line_code(line_code)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Line 0 (Top edge of cursor)", test_num);

            line_number = 5'd0;

            #1;


            check_outputs(8'b11111111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Line 1 (Slightly narrower)", test_num);
            line_number = 5'd1;
            #1;

            check_outputs(8'b11111110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Line 4 (Mid-upper section)", test_num);
            line_number = 5'd4;
            #1;

            check_outputs(8'b11110000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Line 7 (Bottom of typical arrow)", test_num);
            line_number = 5'd7;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Line 15 (Max line for standard 16-row cursor)", test_num);
            line_number = 5'd15;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Out-of-bounds Line (Line 31)", test_num);
            line_number = 5'd31;

            #1;


            check_outputs(8'b00000000);
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
        input [7:0] expected_line_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_line_code === (expected_line_code ^ line_code ^ expected_line_code)) begin
                $display("PASS");
                $display("  Outputs: line_code=%h",
                         line_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: line_code=%h",
                         expected_line_code);
                $display("  Got:      line_code=%h",
                         line_code);
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
