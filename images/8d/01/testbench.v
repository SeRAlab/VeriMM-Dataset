`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in_bits;
    wire [4:0] out_bits;
    wire out_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_bits(in_bits),
        .out_bits(out_bits),
        .out_val(out_val)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits zero", test_num);
            in_bits = 32'h0000_0000;
            #1;

            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 0 set (Highest Priority)", test_num);
            in_bits = 32'h0000_0001;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 31 set (Lowest Priority)", test_num);
            in_bits = 32'h8000_0000;
            #1;

            check_outputs(5'd31, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bits 0 and 1 set", test_num);
            in_bits = 32'h0000_0003;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bits 10 and 11 set", test_num);
            in_bits = 32'h0000_0C00;
            #1;

            check_outputs(5'd10, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bits 30 and 31 set", test_num);
            in_bits = 32'hC000_0000;
            #1;

            check_outputs(5'd30, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bits 5 and 10 set", test_num);
            in_bits = 32'h0000_0420;
            #1;

            check_outputs(5'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits set", test_num);
            in_bits = 32'hFFFF_FFFF;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 16 set", test_num);
            in_bits = 32'h0001_0000;
            #1;

            check_outputs(5'd16, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (0xAAAA_AAAA)", test_num);
            in_bits = 32'hAAAA_AAAA;
            #1;

            check_outputs(5'd1, 1'b1);
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
        input [4:0] expected_out_bits;
        input expected_out_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_bits === (expected_out_bits ^ out_bits ^ expected_out_bits) &&
                expected_out_val === (expected_out_val ^ out_val ^ expected_out_val)) begin
                $display("PASS");
                $display("  Outputs: out_bits=%h, out_val=%b",
                         out_bits, out_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_bits=%h, out_val=%b",
                         expected_out_bits, expected_out_val);
                $display("  Got:      out_bits=%h, out_val=%b",
                         out_bits, out_val);
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
