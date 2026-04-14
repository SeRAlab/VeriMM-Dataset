`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [2:0] signal_in;
    wire [2:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .control(control),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

        begin
            test_num = 1;
            control = 2'b00;
            signal_in = 3'd0;
            $display("Testcase %0d: 0 Degree Shift - Input 0", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            control = 2'b00;
            signal_in = 3'd7;
            $display("Testcase %0d: 0 Degree Shift - Input 7", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            control = 2'b01;
            signal_in = 3'd2;
            $display("Testcase %0d: 90 Degree Shift - Input 2", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            control = 2'b01;
            signal_in = 3'd7;
            $display("Testcase %0d: 90 Degree Shift - Input 7 (Wrap-around)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            control = 2'b10;
            signal_in = 3'd0;
            $display("Testcase %0d: 180 Degree Shift - Input 0", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            control = 2'b10;
            signal_in = 3'd5;
            $display("Testcase %0d: 180 Degree Shift - Input 5 (Wrap-around)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            control = 2'b11;
            signal_in = 3'd1;
            $display("Testcase %0d: 270 Degree Shift - Input 1", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            control = 2'b11;
            signal_in = 3'd6;
            $display("Testcase %0d: 270 Degree Shift - Input 6 (Wrap-around)", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [2:0] expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
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
