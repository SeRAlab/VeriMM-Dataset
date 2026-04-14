`timescale 1ns/1ps

module new_module_17_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg v;
    wire w;
    wire x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_17 dut (
        .clock(clock),
        .v(v),
        .w(w),
        .x(x)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            v = 0;
            @(posedge clock);
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Checking state after 2 pulses of v=1 (Expected w=1, x=1)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(2) @(posedge clock);
            #2 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Checking state after 3 pulses of v=1 (Expected w=0, x=1)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(3) @(posedge clock);
            #2 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Checking state after 4 pulses of v=1 (Expected w=1, x=0)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(4) @(posedge clock);
            #2 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Checking state after 5 pulses of v=1 (Expected w=0, x=1)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(5) @(posedge clock);
            #2 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Checking state after 6 pulses of v=1 (Expected w=1, x=0)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(6) @(posedge clock);
            #2 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Checking enable logic v=0 at State 2 (Expected w=1, x=1)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(2) @(posedge clock);
            v = 0;
            repeat(3) @(posedge clock);
            #2 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Checking enable logic v=0 at State 3 (Expected w=0, x=1)");
            test_num = test_num + 1;
            reset_dut();
            v = 1;
            repeat(3) @(posedge clock);
            v = 0;
            repeat(2) @(posedge clock);
            #2 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_17 Testbench");
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
        input expected_w;
        input expected_x;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: w=%b, x=%b",
                         w, x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b, x=%b",
                         expected_w, expected_x);
                $display("  Got:      w=%b, x=%b",
                         w, x);
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
        $dumpvars(0,clock, v, w, x);
    end

endmodule
