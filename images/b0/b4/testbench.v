`timescale 1ns/1ps

module debounce_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    wire debounced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debounce dut (
        .button(button),
        .clk(clk),
        .debounced(debounced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            button = 0;

            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase001: 3-cycle valid press...");
            @(posedge clk) button = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase002: 2-cycle glitch (should stay low)...");
            @(posedge clk) button = 1;
            @(posedge clk);
            @(posedge clk) button = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase003: 1-cycle glitch (should stay low)...");
            @(posedge clk) button = 1;
            @(posedge clk) button = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase004: 5-cycle long press...");
            @(posedge clk) button = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase005: Release check...");
            @(posedge clk) button = 1;
            repeat(2) @(posedge clk);
            @(posedge clk) button = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Running Testcase006: Intermittent noise check...");
            @(posedge clk) button = 1;
            @(posedge clk) button = 0;
            @(posedge clk) button = 1;
            @(posedge clk) button = 1;
            #1;
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
        input expected_debounced;
        begin
            if (expected_debounced === (expected_debounced ^ debounced ^ expected_debounced)) begin
                $display("PASS");
                $display("  Outputs: debounced=%b",
                         debounced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debounced=%b",
                         expected_debounced);
                $display("  Got:      debounced=%b",
                         debounced);
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
        $dumpvars(0,button, clk, debounced);
    end

endmodule
