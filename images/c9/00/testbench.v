`timescale 1ns/1ps

module sum_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_a;
    wire [4:0] output_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sum_4bit dut (
        .input_a(input_a),
        .output_sum(output_sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All bits zero", test_num);
            input_a = 4'b0000;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Single bit set (LSB)", test_num);
            input_a = 4'b0001;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Single bit set (MSB)", test_num);
            input_a = 4'b1000;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: All bits set", test_num);
            input_a = 4'b1111;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Two bits set (alternating)", test_num);
            input_a = 4'b1010;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Three bits set", test_num);
            input_a = 4'b0111;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Two bits set (adjacent)", test_num);
            input_a = 4'b1100;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Three bits set (mixed)", test_num);
            input_a = 4'b1101;
            #1;

            check_outputs(5'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sum_4bit Testbench");
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
        input [4:0] expected_output_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_sum === (expected_output_sum ^ output_sum ^ expected_output_sum)) begin
                $display("PASS");
                $display("  Outputs: output_sum=%h",
                         output_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_sum=%h",
                         expected_output_sum);
                $display("  Got:      output_sum=%h",
                         output_sum);
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
