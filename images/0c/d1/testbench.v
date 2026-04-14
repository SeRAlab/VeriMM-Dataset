`timescale 1ns/1ps

module wifi_signal_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_strength;
    wire [2:0] signal_quality;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_decoder dut (
        .signal_strength(signal_strength),
        .signal_quality(signal_quality)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Very Weak signal (0)", test_num);
        signal_strength = 5'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Very Weak signal (5)", test_num);
        signal_strength = 5'd5;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Weak signal (6)", test_num);
        signal_strength = 5'd6;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Weak signal (10)", test_num);
        signal_strength = 5'd10;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Fair signal (11)", test_num);
        signal_strength = 5'd11;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Fair signal (15)", test_num);
        signal_strength = 5'd15;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Good signal (16)", test_num);
        signal_strength = 5'd16;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Good signal (20)", test_num);
        signal_strength = 5'd20;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Very Good signal (21)", test_num);
        signal_strength = 5'd21;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Very Good signal (25)", test_num);
        signal_strength = 5'd25;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %0d: Excellent signal (26)", test_num);
        signal_strength = 5'd26;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case %0d: Excellent signal (31)", test_num);
        signal_strength = 5'd31;
        #1;

        check_outputs(3'b101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_decoder Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_signal_quality;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_quality === (expected_signal_quality ^ signal_quality ^ expected_signal_quality)) begin
                $display("PASS");
                $display("  Outputs: signal_quality=%h",
                         signal_quality);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_quality=%h",
                         expected_signal_quality);
                $display("  Got:      signal_quality=%h",
                         signal_quality);
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
