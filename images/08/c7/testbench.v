`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] in_matrix;
    wire out_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .in_matrix(in_matrix),
        .out_bit(out_bit)
    );
    task testcase001;

        begin
            test_num = 1;
            in_matrix = 9'b000_000_000;
            $display("Test %0d: All zeros (Background)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_matrix = 9'b111_111_111;
            $display("Test %0d: All ones (Solid Object)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_matrix = 9'b000_010_000;
            $display("Test %0d: Single bit at center", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_matrix = 9'b000_000_001;
            $display("Test %0d: Single bit at bottom-right corner", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_matrix = 9'b100_000_000;
            $display("Test %0d: Single bit at top-left corner", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_matrix = 9'b010_101_010;
            $display("Test %0d: Checkerboard pattern", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_matrix = 9'b000_000_111;
            $display("Test %0d: Bottom row set", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in_matrix = 9'b000_001_000;
            $display("Test %0d: Sparse bit", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_dilation Testbench");
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
        input expected_out_bit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_bit === (expected_out_bit ^ out_bit ^ expected_out_bit)) begin
                $display("PASS");
                $display("  Outputs: out_bit=%b",
                         out_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_bit=%b",
                         expected_out_bit);
                $display("  Got:      out_bit=%b",
                         out_bit);
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
