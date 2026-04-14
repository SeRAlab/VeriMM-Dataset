`timescale 1ns/1ps

module and_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] const_value;
    reg [31:0] in_signal;
    wire [15:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_module dut (
        .const_value(const_value),
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            in_signal = 32'h00000000;
            const_value = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            in_signal = 32'hFFFFFFFF;
            const_value = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Constant is Zero, Input is Max", test_num);
            in_signal = 32'hFFFFFFFF;
            const_value = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Low 16 bits are Zero", test_num);
            in_signal = 32'hFFFF0000;
            const_value = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (Matching)", test_num);
            in_signal = 32'hAAAA_AAAA;
            const_value = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (Mismatching)", test_num);
            in_signal = 32'hAAAA_AAAA;
            const_value = 16'h5555;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Pattern 1", test_num);
            in_signal = 32'h1234_5678;
            const_value = 16'hF0F0;
            #1;

            check_outputs(16'h5070);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Pattern 2", test_num);
            in_signal = 32'hABCD_EF01;
            const_value = 16'h0FF0;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High 16-bits of input should not affect output", test_num);
            in_signal = 32'hDEAD_BEEF;
            const_value = 16'hFFFF;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit Test", test_num);
            in_signal = 32'h0000_0001;
            const_value = 16'h0001;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_module Testbench");
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
        input [15:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
