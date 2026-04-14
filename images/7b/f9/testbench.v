`timescale 1ns/1ps

module debounce_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg switch_in;
    wire switch_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debounce dut (
        .clk(clk),
        .rst(rst),
        .switch_in(switch_in),
        .switch_out(switch_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            switch_in = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Stable Logic High", test_num);
            reset_dut();
            switch_in = 1;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Glitch Rejection (High Pulse)", test_num);
            reset_dut();
            switch_in = 1;
            repeat(2) @(posedge clk);
            switch_in = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Bouncing High Transition", test_num);
            reset_dut();

            switch_in = 1; #20;
            switch_in = 0; #20;
            switch_in = 1; #30;
            switch_in = 0; #10;

            switch_in = 1;
            repeat(30) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Glitch Rejection (Low Pulse at High)", test_num);
            reset_dut();

            switch_in = 1;
            repeat(20) @(posedge clk);

            switch_in = 0;
            repeat(2) @(posedge clk);
            switch_in = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Bouncing Low Transition", test_num);
            reset_dut();

            switch_in = 1;
            repeat(20) @(posedge clk);

            switch_in = 0; #15;
            switch_in = 1; #15;
            switch_in = 0; #10;
            switch_in = 1; #5;

            switch_in = 0;
            repeat(30) @(posedge clk);
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
        $display("debounce Testbench");
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
        input expected_switch_out;
        begin
            if (expected_switch_out === (expected_switch_out ^ switch_out ^ expected_switch_out)) begin
                $display("PASS");
                $display("  Outputs: switch_out=%b",
                         switch_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: switch_out=%b",
                         expected_switch_out);
                $display("  Got:      switch_out=%b",
                         switch_out);
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
        $dumpvars(0,clk, rst, switch_in, switch_out);
    end

endmodule
