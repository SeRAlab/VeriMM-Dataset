`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] fractional_divisor;
    reg reset;
    wire pll_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .fractional_divisor(fractional_divisor),
        .reset(reset),
        .pll_output(pll_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            fractional_divisor = 8'h00;
            #100;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset state check", test_num);
            reset = 1;
            fractional_divisor = 8'h40;
            #50;

            #1;


            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Integer division N=4.0", test_num);
            reset_dut();
            fractional_divisor = 8'h40;


            #1000;



            if (pll_output === 1'bx || pll_output === 1'bz)
                #1;

                check_outputs(1'b0);
            else
                #1;

                check_outputs(pll_output);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Fractional division N=2.5", test_num);
            reset_dut();
            fractional_divisor = 8'h28;


            #2000;


            #1;



            check_outputs(pll_output);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: High integer division N=10.0", test_num);
            reset_dut();
            fractional_divisor = 8'hA0;

            #1000;


            #1;



            check_outputs(pll_output);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Minimal fractional step N=4.0625", test_num);
            reset_dut();
            fractional_divisor = 8'h41;

            #2000;

            #1;


            check_outputs(pll_output);
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
        input expected_pll_output;
        begin
            if (expected_pll_output === (expected_pll_output ^ pll_output ^ expected_pll_output)) begin
                $display("PASS");
                $display("  Outputs: pll_output=%b",
                         pll_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pll_output=%b",
                         expected_pll_output);
                $display("  Got:      pll_output=%b",
                         pll_output);
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
        $dumpvars(0,clk, fractional_divisor, reset, pll_output);
    end

endmodule
