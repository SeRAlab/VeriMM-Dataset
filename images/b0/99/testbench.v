`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] k;
    wire [10:0] out_diff;
    wire [10:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .k(k),
        .out_diff(out_diff),
        .out_sum(out_sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bits zero", test_num);
            k = 12'b0000_0000_0000;
            #1;

            check_outputs(11'h000, 11'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bits one", test_num);
            k = 12'b1111_1111_1111;
            #1;

            check_outputs(11'h000, 11'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern 0xAAA", test_num);
            k = 12'hAAA;
            #1;

            check_outputs(11'h7FF, 11'h7FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern 0x555", test_num);
            k = 12'h555;
            #1;

            check_outputs(11'h7FF, 11'h7FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single LSB bit set", test_num);
            k = 12'h001;
            #1;

            check_outputs(11'h001, 11'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single MSB bit set", test_num);
            k = 12'h800;
            #1;

            check_outputs(11'h400, 11'h400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pattern 0x00F", test_num);
            k = 12'h00F;


            #1;



            check_outputs(11'h008, 11'h008);
        end
        endtask

    task testcase008;

        reg [10:0] expected_sum;
        reg [10:0] expected_diff;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Pattern 0xC5A", test_num);
            k = 12'hC5A;
            for(i=0; i<11; i=i+1) begin
                expected_sum[i] = k[i] + k[i+1];
                expected_diff[i] = k[i] - k[i+1];
            end
            #1;

            check_outputs(expected_diff, expected_sum);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit blocks 111000111000", test_num);
            k = 12'b111000111000;













            #1;














            check_outputs(11'h091, 11'h091);
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
        input [10:0] expected_out_diff;
        input [10:0] expected_out_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_diff === (expected_out_diff ^ out_diff ^ expected_out_diff) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_diff=%h, out_sum=%h",
                         out_diff, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_diff=%h, out_sum=%h",
                         expected_out_diff, expected_out_sum);
                $display("  Got:      out_diff=%h, out_sum=%h",
                         out_diff, out_sum);
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
