`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_signal;
    wire [3:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        in_signal = 4'd0;
        #1;
        $display("Testcase %0d: Input = %d (Minimum)", test_num, in_signal);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in_signal = 4'd4;
        #1;
        $display("Testcase %0d: Input = %d (Below Threshold)", test_num, in_signal);
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in_signal = 4'd8;
        #1;
        $display("Testcase %0d: Input = %d (Threshold)", test_num, in_signal);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in_signal = 4'd10;
        #1;
        $display("Testcase %0d: Input = %d (Above Threshold, 2:1 Ratio)", test_num, in_signal);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in_signal = 4'd12;
        #1;
        $display("Testcase %0d: Input = %d (Above Threshold, 2:1 Ratio)", test_num, in_signal);
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in_signal = 4'd15;
        #1;
        $display("Testcase %0d: Input = %d (Maximum Input)", test_num, in_signal);
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in_signal = 4'd9;
        #1;
        $display("Testcase %0d: Input = %d (Checking floor division)", test_num, in_signal);
        #1;

        check_outputs(4'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_out_signal;
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
