`timescale 1ns/1ps

module pcie_signal_checker_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [4:0] signal_in;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_signal_checker dut (
        .control(control),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: control=0, signal_in=5'b00000 (Expected: signal_out=1)", test_num);
            control = 1'b0;
            signal_in = 5'b00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: control=0, signal_in=5'b11111 (Expected: signal_out=0)", test_num);
            control = 1'b0;
            signal_in = 5'b11111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: control=0, signal_in=5'b01010 (Expected: signal_out=0)", test_num);
            control = 1'b0;
            signal_in = 5'b01010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: control=1, signal_in=5'b11111 (Expected: signal_out=1)", test_num);
            control = 1'b1;
            signal_in = 5'b11111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: control=1, signal_in=5'b00000 (Expected: signal_out=0)", test_num);
            control = 1'b1;
            signal_in = 5'b00000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: control=1, signal_in=5'b10101 (Expected: signal_out=0)", test_num);
            control = 1'b1;
            signal_in = 5'b10101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: control=0, signal_in=5'b00001 (Expected: signal_out=0)", test_num);
            control = 1'b0;
            signal_in = 5'b00001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: control=1, signal_in=5'b11110 (Expected: signal_out=0)", test_num);
            control = 1'b1;
            signal_in = 5'b11110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_signal_checker Testbench");
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
        input expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
