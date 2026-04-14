`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] signal_d;
    reg [2:0] signal_e;
    wire signal_f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .signal_d(signal_d),
        .signal_e(signal_e),
        .signal_f(signal_f)
    );
    task testcase001;

    begin
        test_num = 1;
        signal_d = 2'd0;
        signal_e = 3'd0;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        signal_d = 2'd1;
        signal_e = 3'd0;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        signal_d = 2'd2;
        signal_e = 3'd2;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        signal_d = 2'd1;
        signal_e = 3'd2;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        signal_d = 2'd3;
        signal_e = 3'd2;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        signal_d = 2'd3;
        signal_e = 3'd3;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        signal_d = 2'd3;
        signal_e = 3'd4;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        signal_d = 2'd3;
        signal_e = 3'd7;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        signal_d = 2'd0;
        signal_e = 3'd1;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        signal_d = 2'd2;
        signal_e = 3'd1;
        $display("Testcase %0d: signal_d=%0d, signal_e=%0d", test_num, signal_d, signal_e);
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
        $display("comparator Testbench");
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
        input expected_signal_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_f === (expected_signal_f ^ signal_f ^ expected_signal_f)) begin
                $display("PASS");
                $display("  Outputs: signal_f=%b",
                         signal_f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_f=%b",
                         expected_signal_f);
                $display("  Got:      signal_f=%b",
                         signal_f);
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
