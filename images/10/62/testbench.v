`timescale 1ns/1ps

module wifi_signal_strength_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] rssi;
    wire [2:0] strength;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_strength dut (
        .rssi(rssi),
        .strength(strength)
    );
    task testcase001;

    begin
        test_num = 1;
        rssi = 4'd0;
        #10;
        $display("Testcase %0d: RSSI = 0 (Lower Bound Level 0)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rssi = 4'd3;
        #10;
        $display("Testcase %0d: RSSI = 3 (Upper Bound Level 0)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rssi = 4'd4;
        #10;
        $display("Testcase %0d: RSSI = 4 (Lower Bound Level 1)", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rssi = 4'd7;
        #10;
        $display("Testcase %0d: RSSI = 7 (Upper Bound Level 1)", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rssi = 4'd8;
        #10;
        $display("Testcase %0d: RSSI = 8 (Lower Bound Level 2)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rssi = 4'd11;
        #10;
        $display("Testcase %0d: RSSI = 11 (Upper Bound Level 2)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rssi = 4'd12;
        #10;
        $display("Testcase %0d: RSSI = 12 (Lower Bound Level 3)", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        rssi = 4'd15;
        #10;
        $display("Testcase %0d: RSSI = 15 (Upper Bound Level 3)", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_strength Testbench");
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
        input [2:0] expected_strength;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strength === (expected_strength ^ strength ^ expected_strength)) begin
                $display("PASS");
                $display("  Outputs: strength=%h",
                         strength);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength=%h",
                         expected_strength);
                $display("  Got:      strength=%h",
                         strength);
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
