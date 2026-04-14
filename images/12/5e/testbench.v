`timescale 1ns/1ps

module wifi_strength_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_strength;
    wire [1:0] strength_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_strength_decoder dut (
        .signal_strength(signal_strength),
        .strength_code(strength_code)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Boundary - Minimum Weak (0)", test_num);
            signal_strength = 5'd0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Mid-range Weak (5)", test_num);
            signal_strength = 5'd5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Boundary - Maximum Weak (10)", test_num);
            signal_strength = 5'd10;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary - Minimum Moderate (11)", test_num);
            signal_strength = 5'd11;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Mid-range Moderate (15)", test_num);
            signal_strength = 5'd15;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary - Maximum Moderate (20)", test_num);
            signal_strength = 5'd20;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Boundary - Minimum Strong (21)", test_num);
            signal_strength = 5'd21;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Mid-range Strong (26)", test_num);
            signal_strength = 5'd26;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Boundary - Maximum Strong (31)", test_num);
            signal_strength = 5'd31;
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_strength_decoder Testbench");
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
        input [1:0] expected_strength_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strength_code === (expected_strength_code ^ strength_code ^ expected_strength_code)) begin
                $display("PASS");
                $display("  Outputs: strength_code=%h",
                         strength_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength_code=%h",
                         expected_strength_code);
                $display("  Got:      strength_code=%h",
                         strength_code);
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
