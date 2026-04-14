`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire out_bit_def;
    wire out_bit_ovr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .out_bit_def(out_bit_def),
        .out_bit_ovr(out_bit_ovr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input all zeros (0 '1's, bit[4]=0)", test_num);
            data = 8'b0000_0000;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Three '1's, bit[4]=0", test_num);
            data = 8'b0000_0111;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exactly four '1's, bit[4]=0", test_num);
            data = 8'b1110_0001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only bit[4] is '1' (1 '1', bit[4]=1)", test_num);
            data = 8'b0001_0000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Four '1's including bit[4]=1", test_num);
            data = 8'b0001_0111;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Five '1's, bit[4]=0", test_num);
            data = 8'b1110_0110;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All eight bits '1'", test_num);
            data = 8'b1111_1111;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check - bits [3:0] are '1', bit[4]=0", test_num);
            data = 8'b0000_1111;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Three '1's including bit[4]=1", test_num);
            data = 8'b0001_1100;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit[4] is 0, but bits [7:5] and bit[0] are 1 (4 total)", test_num);
            data = 8'b1110_0001;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_out_bit_def;
        input expected_out_bit_ovr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_bit_def === (expected_out_bit_def ^ out_bit_def ^ expected_out_bit_def) &&
                expected_out_bit_ovr === (expected_out_bit_ovr ^ out_bit_ovr ^ expected_out_bit_ovr)) begin
                $display("PASS");
                $display("  Outputs: out_bit_def=%b, out_bit_ovr=%b",
                         out_bit_def, out_bit_ovr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_bit_def=%b, out_bit_ovr=%b",
                         expected_out_bit_def, expected_out_bit_ovr);
                $display("  Got:      out_bit_def=%b, out_bit_ovr=%b",
                         out_bit_def, out_bit_ovr);
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
