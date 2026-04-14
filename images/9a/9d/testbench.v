`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i_data;
    wire [3:0] o_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .o_count(o_count)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits zero", test_num);
            i_data = 8'b00000000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits one", test_num);
            i_data = 8'b11111111;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit set (LSB)", test_num);
            i_data = 8'b00000001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit set (MSB)", test_num);
            i_data = 8'b10000000;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits 10101010", test_num);
            i_data = 8'b10101010;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits 01010101", test_num);
            i_data = 8'b01010101;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper nibble high", test_num);
            i_data = 8'hF0;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seven bits high", test_num);
            i_data = 8'b01111111;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern 0xBD", test_num);
            i_data = 8'hBD;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern 0x12", test_num);
            i_data = 8'h12;
            #1;

            check_outputs(4'd2);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_o_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_count === (expected_o_count ^ o_count ^ expected_o_count)) begin
                $display("PASS");
                $display("  Outputs: o_count=%h",
                         o_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_count=%h",
                         expected_o_count);
                $display("  Got:      o_count=%h",
                         o_count);
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
