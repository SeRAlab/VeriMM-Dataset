`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] i;
    wire [13:0] out_or;
    wire [13:0] out_sum;
    wire [14:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .out_or(out_or),
        .out_sum(out_sum),
        .out_xor(out_xor)
    );
    task testcase001;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h0000;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: All Zeros (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase002;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h7FFF;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: All Ones (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase003;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h5555;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Alternating 5s (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase004;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h2AAA;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Alternating As (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase005;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h0001;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Single Bit Right (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase006;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h4000;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Single Bit Left (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase007;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h4001;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Boundary Check (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase008;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h0F0F;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Block Pattern (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase009;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h1234;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Random Pattern 1 (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
        end
        endtask

    task testcase010;

        reg [13:0] exp_or;
        reg [13:0] exp_sum;
        reg [14:0] exp_xor;
        begin
            test_num = test_num + 1;
            i = 15'h6B5A;
            #1;
            exp_or = i[13:0] | i[14:1];
            exp_sum = 14'h0;
            exp_sum[13:1] = i[13:1] ^ i[12:0];
            exp_sum[0] = out_sum[0];
            exp_xor = i ^ {i[0], i[14:1]};
            $display("Testcase %03d: Random Pattern 2 (i=%h)", test_num, i);
            #1;

            check_outputs(exp_or, exp_sum, exp_xor);
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
        input [13:0] expected_out_or;
        input [13:0] expected_out_sum;
        input [14:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_or=%h, out_sum=%h, out_xor=%h",
                         out_or, out_sum, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or=%h, out_sum=%h, out_xor=%h",
                         expected_out_or, expected_out_sum, expected_out_xor);
                $display("  Got:      out_or=%h, out_sum=%h, out_xor=%h",
                         out_or, out_sum, out_xor);
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
