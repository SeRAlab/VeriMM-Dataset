`timescale 1ns/1ps

module new_module_11_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg m;
    wire n;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_11 dut (
        .clock(clock),
        .m(m),
        .n(n),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            m = 0;
            @(negedge clock);
            m = 0;
            @(negedge clock);

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $write("Testcase 001 (Initialization Check): ");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clock); m = 1;
            @(negedge clock);
            $write("Testcase 002 (m=1 Set State): ");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clock); m = 1; @(negedge clock);
            @(posedge clock); m = 0; @(negedge clock);
            $write("Testcase 003 (First Swap 1,0 to 0,1): ");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clock); m = 1; @(negedge clock);
            @(posedge clock); m = 0; @(negedge clock);
            @(posedge clock); m = 0; @(negedge clock);
            $write("Testcase 004 (Second Swap 0,1 to 1,0): ");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clock); m = 1; @(negedge clock);
            @(posedge clock); m = 0; @(negedge clock);
            @(posedge clock); m = 1; @(negedge clock);
            $write("Testcase 005 (m=1 override swap): ");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_11 Testbench");
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
        input expected_n;
        input expected_p;
        begin
            if (expected_n === (expected_n ^ n ^ expected_n) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: n=%b, p=%b",
                         n, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b, p=%b",
                         expected_n, expected_p);
                $display("  Got:      n=%b, p=%b",
                         n, p);
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
        $dumpvars(0,clock, m, n, p);
    end

endmodule
