`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal_in;
    wire recovered_carrier;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .recovered_carrier(recovered_carrier)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting the system...");
            rst = 1;
            signal_in = 0;
            #100;
            rst = 0;
            #50;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Locking to 25MHz nominal frequency", test_num);
            reset_dut();


            drive_frequency(20, 10000);



            #1;




            check_outputs(signal_in);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Locking to 50MHz frequency", test_num);
            reset_dut();


            drive_frequency(10, 10000);

            #1;


            check_outputs(signal_in);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Locking to 12.5MHz frequency", test_num);
            reset_dut();


            drive_frequency(40, 15000);

            #1;


            check_outputs(signal_in);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Frequency shift recovery", test_num);
            reset_dut();


            drive_frequency(25, 5000);

            drive_frequency(15, 10000);

            #1;


            check_outputs(signal_in);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Long duration stability test", test_num);
            reset_dut();


            drive_frequency(20, 50000);

            #1;


            check_outputs(signal_in);
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
        input expected_recovered_carrier;
        begin
            if (expected_recovered_carrier === (expected_recovered_carrier ^ recovered_carrier ^ expected_recovered_carrier)) begin
                $display("PASS");
                $display("  Outputs: recovered_carrier=%b",
                         recovered_carrier);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_carrier=%b",
                         expected_recovered_carrier);
                $display("  Got:      recovered_carrier=%b",
                         recovered_carrier);
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
        $dumpvars(0,clk, rst, signal_in, recovered_carrier);
    end

endmodule
