`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg phaseA;
    reg phaseB;
    wire output_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk(clk),
        .phaseA(phaseA),
        .phaseB(phaseB),
        .output_state(output_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            phaseA = 0;
            phaseB = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Phase A leads Phase B (A=1, B=0)", test_num);
            reset_dut();
            phaseA = 1;
            phaseB = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Phase B leads Phase A (A=0, B=1)", test_num);
            reset_dut();
            phaseA = 0;
            phaseB = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold '1' state (A=1, B=0 -> A=0, B=0)", test_num);
            reset_dut();

            phaseA = 1;
            phaseB = 0;
            @(posedge clk);
            #2;

            phaseA = 0;
            phaseB = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold '1' state (A=1, B=0 -> A=1, B=1)", test_num);
            reset_dut();

            phaseA = 1;
            phaseB = 0;
            @(posedge clk);
            #2;

            phaseA = 1;
            phaseB = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold '0' state (A=0, B=1 -> A=0, B=0)", test_num);
            reset_dut();

            phaseA = 0;
            phaseB = 1;
            @(posedge clk);
            #2;

            phaseA = 0;
            phaseB = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold '0' state (A=0, B=1 -> A=1, B=1)", test_num);
            reset_dut();

            phaseA = 0;
            phaseB = 1;
            @(posedge clk);
            #2;

            phaseA = 1;
            phaseB = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic transition (A leads -> B leads)", test_num);
            reset_dut();

            phaseA = 1;
            phaseB = 0;
            @(posedge clk);
            #2;

            phaseA = 0;
            phaseB = 1;
            @(posedge clk);
            #2;
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
        $display("phase_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_output_state;
        begin
            if (expected_output_state === (expected_output_state ^ output_state ^ expected_output_state)) begin
                $display("PASS");
                $display("  Outputs: output_state=%b",
                         output_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_state=%b",
                         expected_output_state);
                $display("  Got:      output_state=%b",
                         output_state);
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
        $dumpvars(0,clk, phaseA, phaseB, output_state);
    end

endmodule
