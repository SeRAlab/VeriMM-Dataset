`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data;
    reg [4:0] i_select;
    wire o_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data(i_data),
        .i_select(i_select),
        .o_result(o_result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select bit 0 (LSB) - expect 1", test_num);
            i_data = 32'h00000001;
            i_select = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select bit 31 (MSB) - expect 1", test_num);
            i_data = 32'h80000000;
            i_select = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select middle bit 15 - expect 1", test_num);
            i_data = 32'h00008000;
            i_select = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select bit 15 from inverted pattern - expect 0", test_num);
            i_data = 32'hFFFF7FFF;
            i_select = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All ones data - expect 1", test_num);
            i_data = 32'hFFFFFFFF;
            i_select = 5'd22;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All zeros data - expect 0", test_num);
            i_data = 32'h00000000;
            i_select = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Alternating pattern (0xAAAAAAAA), select bit 1 - expect 1", test_num);
            i_data = 32'hAAAAAAAA;
            i_select = 5'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Alternating pattern (0xAAAAAAAA), select bit 0 - expect 0", test_num);
            i_data = 32'hAAAAAAAA;
            i_select = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Walking 1s (bit 5) - expect 1", test_num);
            i_data = (32'h1 << 5);
            i_select = 5'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Walking 1s (bit 5 selected but bit 6 is high) - expect 0", test_num);
            i_data = (32'h1 << 6);
            i_select = 5'd5;
            #1;

            check_outputs(1'b0);
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
        input expected_o_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_result === (expected_o_result ^ o_result ^ expected_o_result)) begin
                $display("PASS");
                $display("  Outputs: o_result=%b",
                         o_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_result=%b",
                         expected_o_result);
                $display("  Got:      o_result=%b",
                         o_result);
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
