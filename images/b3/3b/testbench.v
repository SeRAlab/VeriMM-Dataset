`timescale 1ns/1ps

module new_module_14_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg k;
    wire l;
    wire m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_14 dut (
        .clock(clock),
        .k(k),
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
            k = 0;
            @(posedge clock);
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: (0,0) --k=1--> (1,0)", test_num);
            k = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: (1,0) --k=1--> (0,1)", test_num);

            k = 1;
            @(posedge clock);
            #1;

            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: (0,1) --k=1--> (1,0)", test_num);

            k = 1;
            @(posedge clock);
            #1;

            @(posedge clock);
            #1;

            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: k=0 should hold l, m follows l", test_num);

            k = 1;
            @(posedge clock);
            #1;

            k = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_14 Testbench");
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
        $dumpvars(0,clock, k, l, m);
    end

endmodule
