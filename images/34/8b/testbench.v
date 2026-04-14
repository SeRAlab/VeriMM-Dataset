`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk_a;
    reg clk_b;
    reg reset;
    wire phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .clk_a(clk_a),
        .clk_b(clk_b),
        .reset(reset),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;
    end

        task reset_dut;

    begin
        reset = 1;
        clk_b = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: clk_a leads clk_b", test_num);
        reset_dut();



        repeat(5) begin
            @(posedge clk_a);
            #2 clk_b = 1;
            #5 clk_b = 0;
        end

        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: clk_b leads clk_a", test_num);
        reset_dut();




        #3 clk_b = 1; #5 clk_b = 0;
        repeat(5) begin
            @(negedge clk_a);
            #3 clk_b = 1;
            #5 clk_b = 0;
        end

        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Transition from clk_a leading to clk_b leading", test_num);
        reset_dut();


        repeat(3) begin
            @(posedge clk_a);
            #2 clk_b = 1; #5 clk_b = 0;
        end


        repeat(3) begin
            @(negedge clk_a);
            #3 clk_b = 1; #5 clk_b = 0;
        end

        #10;
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
        $dumpvars(0,clk_a, clk_b, reset, phase_out);
    end

endmodule
