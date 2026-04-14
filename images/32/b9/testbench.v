`timescale 1ns/1ps

module bluetooth_strength_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_strength_a;
    reg [4:0] signal_strength_b;
    wire [1:0] strength_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_strength_comparator dut (
        .signal_strength_a(signal_strength_a),
        .signal_strength_b(signal_strength_b),
        .strength_output(strength_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd10;
            signal_strength_b = 5'd5;
            $display("Testcase %0d: A(10) > B(5)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd3;
            signal_strength_b = 5'd12;
            $display("Testcase %0d: A(3) < B(12)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd0;
            signal_strength_b = 5'd0;
            $display("Testcase %0d: A(0) == B(0)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd15;
            signal_strength_b = 5'd15;
            $display("Testcase %0d: A(15) == B(15)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd31;
            signal_strength_b = 5'd31;
            $display("Testcase %0d: A(31) == B(31) [Max Values]", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd31;
            signal_strength_b = 5'd0;
            $display("Testcase %0d: A(31) > B(0) [Edge Case]", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd0;
            signal_strength_b = 5'd31;
            $display("Testcase %0d: A(0) < B(31) [Edge Case]", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd17;
            signal_strength_b = 5'd16;
            $display("Testcase %0d: A(17) > B(16) [Off-by-one]", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd24;
            signal_strength_b = 5'd25;
            $display("Testcase %0d: A(24) < B(25) [Off-by-one]", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            signal_strength_a = 5'd1;
            signal_strength_b = 5'd0;
            $display("Testcase %0d: A(1) > B(0)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_strength_comparator Testbench");
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
        input [1:0] expected_strength_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strength_output === (expected_strength_output ^ strength_output ^ expected_strength_output)) begin
                $display("PASS");
                $display("  Outputs: strength_output=%h",
                         strength_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength_output=%h",
                         expected_strength_output);
                $display("  Got:      strength_output=%h",
                         strength_output);
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
