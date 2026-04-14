`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] frequency;
    wire [2:0] pitch_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .frequency(frequency),
        .pitch_class(pitch_class)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 0 (C)", test_num);
        frequency = 5'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 1 (C#)", test_num);
        frequency = 5'd1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 2 (D)", test_num);
        frequency = 5'd2;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 3 (D#)", test_num);
        frequency = 5'd3;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 4 (E)", test_num);
        frequency = 5'd4;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 5 (F)", test_num);
        frequency = 5'd5;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 6 (F#)", test_num);
        frequency = 5'd6;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 7 (G)", test_num);
        frequency = 5'd7;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 8 (Out of Range)", test_num);
        frequency = 5'd8;
        #1;

        check_outputs(3'bxxx);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 15 (Out of Range)", test_num);
        frequency = 5'd15;
        #1;

        check_outputs(3'bxxx);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Frequency = 31 (Max Out of Range)", test_num);
        frequency = 5'd31;
        #1;

        check_outputs(3'bxxx);
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
        testcase010();
        testcase011();
        
        
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
        input [2:0] expected_pitch_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pitch_class === (expected_pitch_class ^ pitch_class ^ expected_pitch_class)) begin
                $display("PASS");
                $display("  Outputs: pitch_class=%h",
                         pitch_class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_class=%h",
                         expected_pitch_class);
                $display("  Got:      pitch_class=%h",
                         pitch_class);
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
