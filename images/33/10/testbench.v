`timescale 1ns/1ps

module wifi_signal_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_a;
    reg [4:0] signal_b;
    wire [2:0] output_strength;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_comparator dut (
        .signal_a(signal_a),
        .signal_b(signal_b),
        .output_strength(output_strength)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal signals (0 vs 0)", test_num);
            signal_a = 5'd0;
            signal_b = 5'd0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal signals (Max value 31 vs 31)", test_num);
            signal_a = 5'd31;
            signal_b = 5'd31;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: signal_a > signal_b (Small difference)", test_num);
            signal_a = 5'd10;
            signal_b = 5'd9;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: signal_a > signal_b (Large difference)", test_num);
            signal_a = 5'd31;
            signal_b = 5'd0;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: signal_a < signal_b (Small difference)", test_num);
            signal_a = 5'd15;
            signal_b = 5'd16;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: signal_a < signal_b (Large difference)", test_num);
            signal_a = 5'd1;
            signal_b = 5'd30;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: signal_a > signal_b (Mid range)", test_num);
            signal_a = 5'd20;
            signal_b = 5'd10;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: signal_a < signal_b (Mid range)", test_num);
            signal_a = 5'd5;
            signal_b = 5'd25;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal signals (Mid range)", test_num);
            signal_a = 5'd15;
            signal_b = 5'd15;
            #1;

            check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_comparator Testbench");
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
        input [2:0] expected_output_strength;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_strength === (expected_output_strength ^ output_strength ^ expected_output_strength)) begin
                $display("PASS");
                $display("  Outputs: output_strength=%h",
                         output_strength);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_strength=%h",
                         expected_output_strength);
                $display("  Got:      output_strength=%h",
                         output_strength);
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
