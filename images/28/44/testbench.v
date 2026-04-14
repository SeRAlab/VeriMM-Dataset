`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk_a;
    reg clk_b;
    reg clk_ref;
    wire [1:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk_a(clk_a),
        .clk_b(clk_b),
        .clk_ref(clk_ref),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

    begin
        clk_a = 0;
        clk_b = 0;
        repeat(5) @(posedge clk_ref);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: In-phase signals", test_num);
        @(negedge clk_ref);
        clk_a = 1;
        clk_b = 1;
        @(posedge clk_ref);
        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: clk_a leading clk_b", test_num);
        @(negedge clk_ref);
        clk_a = 1;
        @(posedge clk_ref);
        @(negedge clk_ref);
        clk_b = 1;
        @(posedge clk_ref);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: clk_a lagging clk_b", test_num);
        @(negedge clk_ref);
        clk_b = 1;
        @(posedge clk_ref);
        @(negedge clk_ref);
        clk_a = 1;
        @(posedge clk_ref);
        #2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Transition from in-phase to clk_a leading", test_num);

        @(negedge clk_ref);
        clk_a = 1; clk_b = 1;
        @(posedge clk_ref);

        @(negedge clk_ref);
        clk_a = 0; clk_b = 0;
        @(posedge clk_ref);

        @(negedge clk_ref);
        clk_a = 1;
        @(posedge clk_ref);
        @(negedge clk_ref);
        clk_b = 1;
        @(posedge clk_ref);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: clk_a lagging clk_b by multiple cycles", test_num);
        @(negedge clk_ref);
        clk_b = 1;
        repeat(3) @(posedge clk_ref);
        @(negedge clk_ref);
        clk_a = 1;
        @(posedge clk_ref);
        #2;
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
        $display("phase_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_phase_out;
        begin
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%h",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%h",
                         expected_phase_out);
                $display("  Got:      phase_out=%h",
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
        $dumpvars(0,clk_a, clk_b, clk_ref, phase_out);
    end

endmodule
