`timescale 1ns/1ps

module light_switch_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg switch_off;
    reg switch_on;
    wire light_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    light_switch_controller dut (
        .areset(areset),
        .clk(clk),
        .switch_off(switch_off),
        .switch_on(switch_on),
        .light_on(light_on)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        switch_on = 0;
        switch_off = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset State (Light_Off)", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transition Off -> On", test_num);
        reset_dut();
        @(posedge clk);
        switch_on = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Transition Off -> On -> Off", test_num);
        reset_dut();
        @(posedge clk);
        switch_on = 1;
        @(posedge clk);
        switch_on = 0;
        switch_off = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Stay in Off state", test_num);
        reset_dut();
        switch_on = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Stay in On state", test_num);
        reset_dut();
        switch_on = 1;
        @(posedge clk);
        switch_on = 0;
        switch_off = 0;
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
        $display("Testcase %0d: Asynchronous Reset from On state", test_num);
        reset_dut();
        switch_on = 1;
        @(posedge clk);
        #2;
        areset = 1;
        #2;
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
        $display("light_switch_controller Testbench");
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
        input expected_light_on;
        begin
            if (expected_light_on === (expected_light_on ^ light_on ^ expected_light_on)) begin
                $display("PASS");
                $display("  Outputs: light_on=%b",
                         light_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: light_on=%b",
                         expected_light_on);
                $display("  Got:      light_on=%b",
                         light_on);
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
        $dumpvars(0,areset, clk, switch_off, switch_on, light_on);
    end

endmodule
