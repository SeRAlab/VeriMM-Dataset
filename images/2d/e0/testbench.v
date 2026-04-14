`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_signal;
    reg reset;
    wire vco_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk(clk),
        .input_signal(input_signal),
        .reset(reset),
        .vco_output(vco_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_signal = 0;
            #100;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Locking to 10MHz Signal", test_num);
            reset_dut();


            drive_input(100, 50000);





            #1;






            check_outputs(input_signal);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Locking to 5MHz Signal", test_num);
            reset_dut();


            drive_input(200, 50000);


            #1;



            check_outputs(input_signal);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Locking to 20MHz Signal", test_num);
            reset_dut();


            drive_input(50, 50000);


            #1;



            check_outputs(input_signal);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Frequency Step Tracking", test_num);
            reset_dut();


            drive_input(100, 25000);

            drive_input(125, 25000);


            #1;



            check_outputs(input_signal);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Frequency Lock (25MHz)", test_num);
            reset_dut();


            drive_input(40, 50000);

            #1;


            check_outputs(input_signal);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll Testbench");
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
        input expected_vco_output;
        begin
            if (expected_vco_output === (expected_vco_output ^ vco_output ^ expected_vco_output)) begin
                $display("PASS");
                $display("  Outputs: vco_output=%b",
                         vco_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vco_output=%b",
                         expected_vco_output);
                $display("  Got:      vco_output=%b",
                         vco_output);
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
        $dumpvars(0,clk, input_signal, reset, vco_output);
    end

endmodule
