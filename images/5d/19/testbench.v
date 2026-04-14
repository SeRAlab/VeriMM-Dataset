`timescale 1ns/1ps

module microwave_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg start_button;
    reg stop_button;
    wire microwave_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    microwave_controller dut (
        .areset(areset),
        .clk(clk),
        .start_button(start_button),
        .stop_button(stop_button),
        .microwave_on(microwave_on)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        start_button = 0;
        stop_button = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Check initial state after reset", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Transition Off -> On via start_button", test_num);
        reset_dut();
        @(posedge clk);
        start_button <= 1;
        @(posedge clk);
        start_button <= 0;
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Transition On -> Off via stop_button", test_num);
        reset_dut();

        @(posedge clk);
        start_button <= 1;
        @(posedge clk);
        start_button <= 0;

        @(posedge clk);
        stop_button <= 1;
        @(posedge clk);
        stop_button <= 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Stay in Off when start_button is 0", test_num);
        reset_dut();
        @(posedge clk);
        start_button <= 0;
        stop_button <= 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Stay in On when stop_button is 0", test_num);
        reset_dut();
        @(posedge clk);
        start_button <= 1;
        @(posedge clk);
        start_button <= 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Asynchronous reset while On", test_num);
        reset_dut();
        @(posedge clk);
        start_button <= 1;
        @(posedge clk);
        #2;
        areset = 1;
        #1;
        #1;

        check_outputs(1'b0);
        areset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("microwave_controller Testbench");
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
        input expected_microwave_on;
        begin
            if (expected_microwave_on === (expected_microwave_on ^ microwave_on ^ expected_microwave_on)) begin
                $display("PASS");
                $display("  Outputs: microwave_on=%b",
                         microwave_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: microwave_on=%b",
                         expected_microwave_on);
                $display("  Got:      microwave_on=%b",
                         microwave_on);
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
        $dumpvars(0,areset, clk, start_button, stop_button, microwave_on);
    end

endmodule
