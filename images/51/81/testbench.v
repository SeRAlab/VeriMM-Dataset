`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in_row;
    wire [4:0] out_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_row(in_row),
        .out_code(out_code)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b000", test_num);
            in_row = 3'b000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b001", test_num);
            in_row = 3'b001;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b010", test_num);
            in_row = 3'b010;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b011", test_num);
            in_row = 3'b011;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b100", test_num);
            in_row = 3'b100;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b101", test_num);
            in_row = 3'b101;
            #1;

            check_outputs(5'b00101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b110", test_num);
            in_row = 3'b110;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in_row = 3'b111", test_num);
            in_row = 3'b111;
            #1;

            check_outputs(5'b00111);
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
        input [4:0] expected_out_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_code === (expected_out_code ^ out_code ^ expected_out_code)) begin
                $display("PASS");
                $display("  Outputs: out_code=%h",
                         out_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_code=%h",
                         expected_out_code);
                $display("  Got:      out_code=%h",
                         out_code);
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
