`timescale 1ns/1ps

module rc_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire osc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rc_oscillator dut (
        .clk(clk),
        .reset(reset),
        .osc_out(osc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking output before reach count limit", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking output after first toggle threshold", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking output after two toggle events (Full Cycle)", test_num);
            reset_dut();

            repeat(20) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking long term oscillation (3 toggles)", test_num);
            reset_dut();

            repeat(30) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying reset during active oscillation", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #2;
            if (osc_out === 1'b1) begin
                reset = 1;
                #20;
                reset = 0;
                @(posedge clk);
                #2;

                #1;


                check_outputs(1'b0);
            end else begin
                $display("Skipping sub-check: osc_out didn't reach 1 as expected for this test logic.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rc_oscillator Testbench");
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
        input expected_osc_out;
        begin
            if (expected_osc_out === (expected_osc_out ^ osc_out ^ expected_osc_out)) begin
                $display("PASS");
                $display("  Outputs: osc_out=%b",
                         osc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: osc_out=%b",
                         expected_osc_out);
                $display("  Got:      osc_out=%b",
                         osc_out);
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
        $dumpvars(0,clk, reset, osc_out);
    end

endmodule
