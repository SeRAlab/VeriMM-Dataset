`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] phase_in;
    wire phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_in(phase_in),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #22;
            @(negedge clk);
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Phase 0 (Expect output at Cycle 0)");
            test_num = 1;
            phase_in = 3'd0;
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Phase 1 (Expect output at Cycle 1)");
            test_num = 2;
            phase_in = 3'd1;
            reset_dut();
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Phase 3 (Expect output at Cycle 3)");
            test_num = 3;
            phase_in = 3'd3;
            reset_dut();
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Phase 7 (Expect output at Cycle 7)");
            test_num = 4;
            phase_in = 3'd7;
            reset_dut();
            repeat(7) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Phase 4, check Cycle 2 (Expect 0)");
            test_num = 5;
            phase_in = 3'd4;
            reset_dut();
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Phase 2 (Expect output at Cycle 2)");
            test_num = 6;
            phase_in = 3'd2;
            reset_dut();
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Phase 5 (Expect output at Cycle 5)");
            test_num = 7;
            phase_in = 3'd5;
            reset_dut();
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Phase 1, check Cycle 3 (Expect 0 if pulse)");
            test_num = 8;
            phase_in = 3'd1;
            reset_dut();
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
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
        input expected_phase_out;
        begin
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%b",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%b",
                         expected_phase_out);
                $display("  Got:      phase_out=%b",
                         phase_out);
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
        $dumpvars(0,clk, phase_in, phase_out);
    end

endmodule
