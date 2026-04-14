`timescale 1ns/1ps

module another_different_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg u;
    wire l;
    wire m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    another_different_module dut (
        .clock(clock),
        .u(u),
        .l(l),
        .m(m)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin



        u = 0;
        #10;
    end
    endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=1 for 1 cycle", test_num);
        reset_dut();
        u = 1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 1'bx);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=1 for 2 cycles", test_num);
        reset_dut();
        u = 1;
        @(posedge clock);
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=1 for 3 cycles", test_num);
        reset_dut();
        u = 1;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=1 for 4 cycles (cycling back)", test_num);
        reset_dut();
        u = 1;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=0 transition from (1,0)", test_num);
        reset_dut();
        u = 1;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        u = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=0 transition from (0,1)", test_num);
        reset_dut();
        u = 1;
        @(posedge clock);
        u = 0;
        @(posedge clock);
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b1, 1'b1);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: u=0 idle state", test_num);
        reset_dut();
        u = 0;
        @(posedge clock);
        @(posedge clock);
        #2;
        #1;

        check_outputs(1'b0, 1'b0);
    end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("another_different_module Testbench");
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
        input expected_l;
        input expected_m;
        begin
            if (expected_l === (expected_l ^ l ^ expected_l) &&
                expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: l=%b, m=%b",
                         l, m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l=%b, m=%b",
                         expected_l, expected_m);
                $display("  Got:      l=%b, m=%b",
                         l, m);
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
        $dumpvars(0,clock, u, l, m);
    end

endmodule
