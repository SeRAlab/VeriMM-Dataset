`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_state;
    reg [4:0] input_signal;
    reg [2:0] scale_factor;
    wire [4:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .current_state(current_state),
        .input_signal(input_signal),
        .scale_factor(scale_factor),
        .next_state(next_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs", test_num);
            current_state = 5'd0;
            input_signal = 5'd0;
            scale_factor = 3'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple scale factor 1", test_num);
            current_state = 5'd5;
            input_signal = 5'd2;
            scale_factor = 3'd1;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Medium scaling", test_num);
            current_state = 5'd10;
            input_signal = 5'd3;
            scale_factor = 3'd4;
            #1;

            check_outputs(5'd22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero scale factor", test_num);
            current_state = 5'd15;
            input_signal = 5'd10;
            scale_factor = 3'd0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input signal", test_num);
            current_state = 5'd20;
            input_signal = 5'd0;
            scale_factor = 3'd7;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow/Wrapping logic", test_num);
            current_state = 5'd25;
            input_signal = 5'd5;
            scale_factor = 3'd2;

            #1;


            check_outputs(5'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max scale factor", test_num);
            current_state = 5'd1;
            input_signal = 5'd4;
            scale_factor = 3'd7;
            #1;

            check_outputs(5'd29);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values wrap-around", test_num);
            current_state = 5'd31;
            input_signal = 5'd31;
            scale_factor = 3'd7;


            #1;



            check_outputs(5'd24);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [4:0] expected_next_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
