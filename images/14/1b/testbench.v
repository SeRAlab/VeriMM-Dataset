`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_signal;
    reg rst;
    wire vco_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk(clk),
        .input_signal(input_signal),
        .rst(rst),
        .vco_output(vco_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_signal = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Basic Frequency Locking (40ns period)", test_num);
            reset_dut();


            repeat (200) begin
                input_signal = 1; #20;
                input_signal = 0; #20;
            end



            #1;




            check_outputs(input_signal);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Higher Frequency Locking (20ns period)", test_num);
            reset_dut();

            repeat (400) begin
                input_signal = 1; #10;
                input_signal = 0; #10;
            end

            #1;


            check_outputs(input_signal);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Lower Frequency Locking (60ns period)", test_num);
            reset_dut();

            repeat (150) begin
                input_signal = 1; #30;
                input_signal = 0; #30;
            end

            #1;


            check_outputs(input_signal);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Recovery after Reset", test_num);
            reset_dut();


            repeat (100) begin
                input_signal = 1; #20;
                input_signal = 0; #20;
            end


            rst = 1; #50; rst = 0;


            repeat (200) begin
                input_signal = 1; #20;
                input_signal = 0; #20;
            end

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
        $dumpvars(0,clk, input_signal, rst, vco_output);
    end

endmodule
