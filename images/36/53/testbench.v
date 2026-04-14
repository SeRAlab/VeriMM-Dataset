`timescale 1ns/1ps

module i2c_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    reg stop;
    wire scl;
    wire start_signal;
    wire stop_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_master dut (
        .clk(clk),
        .start(start),
        .stop(stop),
        .scl(scl),
        .start_signal(start_signal),
        .stop_signal(stop_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            stop = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Checking IDLE state...", test_num);




            #50;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Verifying START signal...", test_num);

            start = 1;
            #10;
            start = 0;


            #40;


            #1;



            check_outputs(scl, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Verifying STOP signal...", test_num);

            stop = 1;
            #10;
            stop = 0;


            #40;

            #1;


            check_outputs(scl, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Checking SCL activity after START...", test_num);

            start = 1;
            #10;
            start = 0;


            #100;




            #1;





            check_outputs(scl, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Sequential START then STOP...", test_num);


            start = 1;
            #10;
            start = 0;
            #100;


            stop = 1;
            #10;
            stop = 0;
            #50;


            #1;



            check_outputs(scl, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_master Testbench");
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
        input expected_scl;
        input expected_start_signal;
        input expected_stop_signal;
        begin
            if (expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_start_signal === (expected_start_signal ^ start_signal ^ expected_start_signal) &&
                expected_stop_signal === (expected_stop_signal ^ stop_signal ^ expected_stop_signal)) begin
                $display("PASS");
                $display("  Outputs: scl=%b, start_signal=%b, stop_signal=%b",
                         scl, start_signal, stop_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scl=%b, start_signal=%b, stop_signal=%b",
                         expected_scl, expected_start_signal, expected_stop_signal);
                $display("  Got:      scl=%b, start_signal=%b, stop_signal=%b",
                         scl, start_signal, stop_signal);
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
        $dumpvars(0,clk, start, stop, scl, start_signal, stop_signal);
    end

endmodule
