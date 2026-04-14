`timescale 1ns/1ps

module new_module_10_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clock;
    wire b;
    wire c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_10 dut (
        .a(a),
        .clock(clock),
        .b(b),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            a = 0;
            @(negedge clock);

            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at T=10ns (after 1st pulse)", test_num);
            a = 1; @(posedge clock);
            #5 a = 0;
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at T=20ns (after 2nd pulse)", test_num);
            a = 1; @(posedge clock);
            #5 a = 0;
            #5 a = 1; @(posedge clock);
            #5 a = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at T=30ns (after 3rd pulse)", test_num);
            a = 1; @(posedge clock);
            #5 a = 0; #5;
            a = 1; @(posedge clock);
            #5 a = 0; #5;
            a = 1; @(posedge clock);
            #5 a = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at T=40ns (after 4th pulse)", test_num);
            a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #5 a = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at T=50ns (after 5th pulse)", test_num);
            a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #5 a = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at T=60ns (after 6th pulse)", test_num);
            a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #10; a = 1; @(posedge clock);
            #5;
            #1;

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
        $display("new_module_10 Testbench");
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
        input expected_b;
        input expected_c;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: b=%b, c=%b",
                         b, c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b, c=%b",
                         expected_b, expected_c);
                $display("  Got:      b=%b, c=%b",
                         b, c);
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
        $dumpvars(0,a, clock, b, c);
    end

endmodule
