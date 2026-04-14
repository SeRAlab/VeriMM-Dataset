`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [7:0] fractional_n;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .fractional_n(fractional_n),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            $display("--- Resetting DUT ---");
            fractional_n = 8'd0;
            #100;
        end
        endtask
    task verify_frequency;

        input [7:0] current_n;
        begin

            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            measured_period = t2 - t1;



            if (current_n > 0) begin
                expected_period = 10.0 / current_n;


                if (measured_period >= (expected_period * 0.99) &&
                    measured_period <= (expected_period * 1.01)) begin
                    $display("Frequency Check: OK. Period: %0.3fns (Exp: %0.3fns)", measured_period, expected_period);
                    #1;

                    check_outputs(clk_out);
                end else begin
                    $display("Frequency Check: FAIL. Period: %0.3fns (Exp: %0.3fns)", measured_period, expected_period);
                    #1;

                    check_outputs(~clk_out);
                end
            end else begin

                $display("Check: Multiplier is 0, frequency undefined.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Multiplier = 2", test_num);
            reset_dut();
            fractional_n = 8'd2;
            #2000;
            verify_frequency(8'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Multiplier = 4", test_num);
            reset_dut();
            fractional_n = 8'd4;
            #2000;
            verify_frequency(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Multiplier = 1", test_num);
            reset_dut();
            fractional_n = 8'd1;
            #2000;
            verify_frequency(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Multiplier = 10", test_num);
            reset_dut();
            fractional_n = 8'd10;
            #2000;
            verify_frequency(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Dynamic Multiplier Change (2 to 5)", test_num);
            reset_dut();
            fractional_n = 8'd2;
            #1000;
            fractional_n = 8'd5;
            #3000;
            verify_frequency(8'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_ref, fractional_n, clk_out);
    end

endmodule
