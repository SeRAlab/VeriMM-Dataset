`timescale 1ns/1ps

module carrier_recovery_PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal_in;
    wire carrier_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_recovery_PLL dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
        .carrier_out(carrier_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        signal_in = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Locking to nominal frequency signal", test_num);
        reset_dut();


        drive_signal(50, 10);


        @(posedge carrier_out);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Locking with phase offset", test_num);
        reset_dut();


        #25;
        drive_signal(50, 15);


        @(posedge clk);
        if (signal_in == 1)
            #1;

            check_outputs(1'b1);
        else
            #1;

            check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Tracking higher frequency", test_num);
        reset_dut();


        drive_signal(40, 20);

        @(posedge clk);
        #1;

        check_outputs(carrier_out);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Signal loss recovery", test_num);
        reset_dut();

        drive_signal(50, 10);
        signal_in = 0;
        repeat(50) @(posedge clk);


        #1;



        check_outputs(carrier_out);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carrier_recovery_PLL Testbench");
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
        input expected_carrier_out;
        begin
            if (expected_carrier_out === (expected_carrier_out ^ carrier_out ^ expected_carrier_out)) begin
                $display("PASS");
                $display("  Outputs: carrier_out=%b",
                         carrier_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carrier_out=%b",
                         expected_carrier_out);
                $display("  Got:      carrier_out=%b",
                         carrier_out);
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
        $dumpvars(0,clk, reset, signal_in, carrier_out);
    end

endmodule
