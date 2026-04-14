`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] frequency;
    wire [2:0] pitch_category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .frequency(frequency),
        .pitch_category(pitch_category)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Low Frequency", test_num);
            frequency = 5'd0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Typical Low Frequency", test_num);
            frequency = 5'd5;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper Boundary of Low Frequency", test_num);
            frequency = 5'd10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower Boundary of Medium Frequency", test_num);
            frequency = 5'd11;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Typical Medium Frequency", test_num);
            frequency = 5'd16;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper Boundary of Medium Frequency", test_num);
            frequency = 5'd21;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower Boundary of High Frequency", test_num);
            frequency = 5'd22;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Typical High Frequency", test_num);
            frequency = 5'd27;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum High Frequency", test_num);
            frequency = 5'd31;
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detector Testbench");
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
        input [2:0] expected_pitch_category;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pitch_category === (expected_pitch_category ^ pitch_category ^ expected_pitch_category)) begin
                $display("PASS");
                $display("  Outputs: pitch_category=%h",
                         pitch_category);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_category=%h",
                         expected_pitch_category);
                $display("  Got:      pitch_category=%h",
                         pitch_category);
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
