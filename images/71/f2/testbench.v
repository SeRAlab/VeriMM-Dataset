`timescale 1ns/1ps

module new_module_3_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg m;
    wire n;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_3 dut (
        .clock(clock),
        .m(m),
        .n(n),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            m = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking outputs after 2 cycles", test_num);
            reset_dut();
            m = 1;
            repeat(2) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking outputs after 3 cycles", test_num);
            reset_dut();
            m = 1;
            repeat(3) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking outputs after 4 cycles", test_num);
            reset_dut();
            m = 1;
            repeat(4) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking outputs after 5 cycles", test_num);
            reset_dut();
            m = 1;
            repeat(5) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking outputs after 6 cycles", test_num);
            reset_dut();
            m = 1;
            repeat(6) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking reset behavior", test_num);
            reset_dut();
            m = 1;
            repeat(4) @(posedge clock);
            m = 0;
            @(posedge clock);
            m = 1;
            repeat(2) @(posedge clock);
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
        $display("new_module_3 Testbench");
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
        input expected_n;
        input expected_z;
        begin
            if (expected_n === (expected_n ^ n ^ expected_n) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: n=%b, z=%b",
                         n, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b, z=%b",
                         expected_n, expected_z);
                $display("  Got:      n=%b, z=%b",
                         n, z);
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
        $dumpvars(0,clock, m, n, z);
    end

endmodule
