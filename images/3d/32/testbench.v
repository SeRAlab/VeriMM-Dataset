`timescale 1ns/1ps

module bluetooth_signal_strength_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] signal_strength;
    wire [2:0] strength_indicator;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_signal_strength dut (
        .signal_strength(signal_strength),
        .strength_indicator(strength_indicator)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Signal Strength 0 (Low)", test_num);
        signal_strength = 4'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Signal Strength 4 (Low)", test_num);
        signal_strength = 4'd4;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Signal Strength 5 (Medium)", test_num);
        signal_strength = 4'd5;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Signal Strength 8 (Medium)", test_num);
        signal_strength = 4'd8;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Signal Strength 10 (Medium)", test_num);
        signal_strength = 4'd10;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Signal Strength 11 (High)", test_num);
        signal_strength = 4'd11;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Signal Strength 13 (High)", test_num);
        signal_strength = 4'd13;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Signal Strength 15 (High)", test_num);
        signal_strength = 4'd15;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Signal Strength 2 (Low)", test_num);
        signal_strength = 4'd2;
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
        $display("bluetooth_signal_strength Testbench");
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
        input [2:0] expected_strength_indicator;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strength_indicator === (expected_strength_indicator ^ strength_indicator ^ expected_strength_indicator)) begin
                $display("PASS");
                $display("  Outputs: strength_indicator=%h",
                         strength_indicator);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength_indicator=%h",
                         expected_strength_indicator);
                $display("  Got:      strength_indicator=%h",
                         strength_indicator);
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
