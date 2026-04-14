`timescale 1ns/1ps

module carrier_recovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg modulated_signal;
    reg reset;
    wire recovered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_recovery dut (
        .clk(clk),
        .modulated_signal(modulated_signal),
        .reset(reset),
        .recovered_signal(recovered_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            modulated_signal = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("\nTestcase %0d: Nominal Frequency Locking (10MHz)", test_num);
            reset_dut();



            for (i = 0; i < 100; i = i + 1) begin
                modulated_signal = 1;
                #50;
                modulated_signal = 0;
                #50;
            end



            #1;




            check_outputs(modulated_signal);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Higher Frequency Locking (~16.6MHz)", test_num);
            reset_dut();



            for (i = 0; i < 150; i = i + 1) begin
                modulated_signal = 1;
                #30;
                modulated_signal = 0;
                #30;
            end

            #1;


            check_outputs(modulated_signal);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Lower Frequency Locking (5MHz)", test_num);
            reset_dut();



            for (i = 0; i < 50; i = i + 1) begin
                modulated_signal = 1;
                #100;
                modulated_signal = 0;
                #100;
            end

            #1;


            check_outputs(modulated_signal);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Frequency Recovery with Phase Shift", test_num);
            reset_dut();


            for (i = 0; i < 50; i = i + 1) begin
                modulated_signal = 1; #50;
                modulated_signal = 0; #50;
            end


            #25;


            for (i = 0; i < 100; i = i + 1) begin
                modulated_signal = 1; #50;
                modulated_signal = 0; #50;
            end

            #1;


            check_outputs(modulated_signal);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Variable Duty Cycle (25%% High, 75%% Low)", test_num);
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                modulated_signal = 1;
                #25;
                modulated_signal = 0;
                #75;
            end

            #1;


            check_outputs(modulated_signal);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carrier_recovery Testbench");
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
        input expected_recovered_signal;
        begin
            if (expected_recovered_signal === (expected_recovered_signal ^ recovered_signal ^ expected_recovered_signal)) begin
                $display("PASS");
                $display("  Outputs: recovered_signal=%b",
                         recovered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_signal=%b",
                         expected_recovered_signal);
                $display("  Got:      recovered_signal=%b",
                         recovered_signal);
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
        $dumpvars(0,clk, modulated_signal, reset, recovered_signal);
    end

endmodule
