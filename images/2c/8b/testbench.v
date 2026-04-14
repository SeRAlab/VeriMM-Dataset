`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_feedback;
    reg clk_ref;
    wire clk_out;
    wire [1:0] phase_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk_feedback(clk_feedback),
        .clk_ref(clk_ref),
        .clk_out(clk_out),
        .phase_error(phase_error)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

    begin
        clk_feedback = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing perfectly aligned clocks (Locked)", test_num);
        reset_dut();
        repeat(20) begin
            @(posedge clk_ref) clk_feedback = 1;
            @(negedge clk_ref) clk_feedback = 0;
        end
        #2;

        #1;


        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Reference leads Feedback (Lagging feedback)", test_num);
        reset_dut();
        repeat(20) begin
            @(posedge clk_ref) #2 clk_feedback = 1;
            @(negedge clk_ref) #2 clk_feedback = 0;
        end
        #1;
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Feedback leads Reference (Advanced feedback)", test_num);
        reset_dut();
        repeat(20) begin
            @(negedge clk_ref);
            #3 clk_feedback = 1;
            @(posedge clk_ref);
            #3 clk_feedback = 0;
        end
        #1;
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing missing feedback signal", test_num);
        reset_dut();
        clk_feedback = 0;
        repeat(10) @(posedge clk_ref);
        #1;

        #1;


        check_outputs(1'b0, 2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_clk_out;
        input [1:0] expected_phase_error;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_phase_error === (expected_phase_error ^ phase_error ^ expected_phase_error)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, phase_error=%h",
                         clk_out, phase_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, phase_error=%h",
                         expected_clk_out, expected_phase_error);
                $display("  Got:      clk_out=%b, phase_error=%h",
                         clk_out, phase_error);
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
        $dumpvars(0,clk_feedback, clk_ref, clk_out, phase_error);
    end

endmodule
