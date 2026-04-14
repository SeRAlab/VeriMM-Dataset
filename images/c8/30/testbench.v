`timescale 1ns/1ps

module constant_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] constant_value;
    reg in_signal;
    wire [3:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    constant_module dut (
        .constant_value(constant_value),
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=0, constant_value=4'hA", test_num);
        in_signal = 1'b0;
        constant_value = 4'hA;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=1, constant_value=4'hA", test_num);
        in_signal = 1'b1;
        constant_value = 4'hA;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=0, constant_value=4'h5", test_num);
        in_signal = 1'b0;
        constant_value = 4'h5;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=1, constant_value=4'h5", test_num);
        in_signal = 1'b1;
        constant_value = 4'h5;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=1, constant_value=4'hF", test_num);
        in_signal = 1'b1;
        constant_value = 4'hF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=1, constant_value=4'h0", test_num);
        in_signal = 1'b1;
        constant_value = 4'h0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: in_signal=0, constant_value=4'hF", test_num);
        in_signal = 1'b0;
        constant_value = 4'hF;
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("constant_module Testbench");
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
