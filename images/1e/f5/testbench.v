`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg signal_A;
    reg signal_B;
    wire [1:0] phase_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk(clk),
        .signal_A(signal_A),
        .signal_B(signal_B),
        .phase_output(phase_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal_A = 0;
            signal_B = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: In-phase signals (simultaneous edges)", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge clk);
                signal_A <= 1;
                signal_B <= 1;
                @(posedge clk);
                signal_A <= 0;
                signal_B <= 0;
            end


            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal A leads Signal B", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge clk);
                signal_A <= 1;
                signal_B <= 0;
                @(posedge clk);
                signal_B <= 1;
                @(posedge clk);
                signal_A <= 0;
                @(posedge clk);
                signal_B <= 0;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal A lags Signal B", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge clk);
                signal_A <= 0;
                signal_B <= 1;
                @(posedge clk);
                signal_A <= 1;
                @(posedge clk);
                signal_B <= 0;
                @(posedge clk);
                signal_A <= 0;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Static Low Signals", test_num);
            reset_dut();

            signal_A <= 0;
            signal_B <= 0;
            repeat(10) @(posedge clk);

            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Static High Signals", test_num);
            reset_dut();

            signal_A <= 1;
            signal_B <= 1;
            repeat(10) @(posedge clk);

            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal A leads Signal B (2-cycle lead)", test_num);
            reset_dut();

            repeat(3) begin
                @(posedge clk);
                signal_A <= 1; signal_B <= 0;
                @(posedge clk);
                signal_A <= 1; signal_B <= 0;
                @(posedge clk);
                signal_A <= 1; signal_B <= 1;
                @(posedge clk);
                signal_A <= 0; signal_B <= 1;
                @(posedge clk);
                signal_A <= 0; signal_B <= 0;
            end

            @(posedge clk);
            #1;
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
        $display("phase_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_phase_output;
        begin
            if (expected_phase_output === (expected_phase_output ^ phase_output ^ expected_phase_output)) begin
                $display("PASS");
                $display("  Outputs: phase_output=%h",
                         phase_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_output=%h",
                         expected_phase_output);
                $display("  Got:      phase_output=%h",
                         phase_output);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, signal_A, signal_B, phase_output);
    end

endmodule
