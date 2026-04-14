`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] input_signal;
    reg [2:0] phase_offset;
    wire [2:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .input_signal(input_signal),
        .phase_offset(phase_offset),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero input and zero offset", test_num);
            input_signal = 3'd0;
            phase_offset = 3'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Standard addition without wrap-around", test_num);
            input_signal = 3'd2;
            phase_offset = 3'd3;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition resulting in exact wrap-around (8)", test_num);
            input_signal = 3'd4;
            phase_offset = 3'd4;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum input with small offset wrap-around", test_num);
            input_signal = 3'd7;
            phase_offset = 3'd1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with wrap-around to middle value", test_num);
            input_signal = 3'd5;
            phase_offset = 3'd6;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum input and maximum offset", test_num);
            input_signal = 3'd7;
            phase_offset = 3'd7;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero input with maximum offset", test_num);
            input_signal = 3'd0;
            phase_offset = 3'd7;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity shift (offset 0) with non-zero input", test_num);
            input_signal = 3'd6;
            phase_offset = 3'd0;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check - result is 7", test_num);
            input_signal = 3'd3;
            phase_offset = 3'd4;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Result wraps back to 1", test_num);
            input_signal = 3'd6;
            phase_offset = 3'd3;
            #1;

            check_outputs(3'd1);
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
        input [2:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
