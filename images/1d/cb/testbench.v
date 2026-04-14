`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] signal1;
    reg [7:0] signal2;
    wire [7:0] mixed_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .signal1(signal1),
        .signal2(signal2),
        .mixed_signal(mixed_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero inputs", test_num);
        signal1 = 8'd0;
        signal2 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple average without wrap", test_num);
        signal1 = 8'd100;
        signal2 = 8'd40;
        #1;

        check_outputs(8'd70);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple average with truncation (odd sum)", test_num);
        signal1 = 8'd50;
        signal2 = 8'd25;
        #1;

        check_outputs(8'd37);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sum equals exactly 256 (Wrap to 0)", test_num);
        signal1 = 8'd128;
        signal2 = 8'd128;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum values (510 mod 256 = 254)", test_num);
        signal1 = 8'd255;
        signal2 = 8'd255;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large sum wrap (300 mod 256 = 44)", test_num);
        signal1 = 8'd200;
        signal2 = 8'd100;
        #1;

        check_outputs(8'd22);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary wrap (255 + 1 = 256 -> 0)", test_num);
        signal1 = 8'd255;
        signal2 = 8'd1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High values mid-range wrap (150 + 150 = 300)", test_num);
        signal1 = 8'd150;
        signal2 = 8'd150;
        #1;

        check_outputs(8'd22);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
        input [7:0] expected_mixed_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mixed_signal === (expected_mixed_signal ^ mixed_signal ^ expected_mixed_signal)) begin
                $display("PASS");
                $display("  Outputs: mixed_signal=%h",
                         mixed_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mixed_signal=%h",
                         expected_mixed_signal);
                $display("  Got:      mixed_signal=%h",
                         mixed_signal);
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
