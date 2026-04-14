`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_signal;
    reg [3:0] phase_ctrl;
    wire [3:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .input_signal(input_signal),
        .phase_ctrl(phase_ctrl),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_signal = 4'b0000;
            phase_ctrl = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b1011;
            phase_ctrl = 4'd0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1011, Phase 0 (No Shift)", test_num);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b1000;
            phase_ctrl = 4'd1;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1000, Phase 1 (Left Rotation)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b0011;
            phase_ctrl = 4'd2;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0011, Phase 2 (Left Rotation)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b0111;
            phase_ctrl = 4'd3;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0111, Phase 3 (Left Rotation)", test_num);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b1101;
            phase_ctrl = 4'd4;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1101, Phase 4 (Full Rotation Cycle)", test_num);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b0001;
            phase_ctrl = 4'd9;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0001, Phase 9 (Equivalent to Phase 1)", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b0001;
            phase_ctrl = 4'd15;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0001, Phase 15 (Equivalent to Phase 3)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b0000;
            phase_ctrl = 4'd2;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0000, Phase 2", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            input_signal = 4'b1111;
            phase_ctrl = 4'd3;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 1111, Phase 3", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [3:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, input_signal, phase_ctrl, output_signal);
    end

endmodule
