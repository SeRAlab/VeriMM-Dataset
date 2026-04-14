`timescale 1ns/1ps

module BufferCC_tb;

    // Testbench signals (sequential circuit)
    reg io_dataIn;
    reg io_mainClk;
    wire io_dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BufferCC dut (
        .io_dataIn(io_dataIn),
        .io_mainClk(io_mainClk),
        .io_dataOut(io_dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        io_mainClk = 0;
        forever #5 io_mainClk = ~io_mainClk;
    end

        task reset_dut;

        begin
            io_dataIn = 0;

            repeat(5) @(posedge io_mainClk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Propagate High signal");
            reset_dut();

            @(negedge io_mainClk);
            io_dataIn = 1;


            repeat(2) @(posedge io_mainClk);

            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Propagate Low signal");
            reset_dut();


            @(negedge io_mainClk);
            io_dataIn = 1;
            @(posedge io_mainClk);

            io_dataIn = 0;
            @(posedge io_mainClk);
            @(posedge io_mainClk);

            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Constant High Input Stability");
            reset_dut();

            @(negedge io_mainClk);
            io_dataIn = 1;


            repeat(4) @(posedge io_mainClk);

            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Pipeline sequence (1-1-0)");
            reset_dut();

            @(negedge io_mainClk);
            io_dataIn = 1;
            @(posedge io_mainClk);
            io_dataIn = 1;
            @(posedge io_mainClk);
            io_dataIn = 0;






            @(posedge io_mainClk);

            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Rapid toggle (1-0-1)");
            reset_dut();

            @(negedge io_mainClk);
            io_dataIn = 1;
            @(posedge io_mainClk);
            io_dataIn = 0;
            @(posedge io_mainClk);
            io_dataIn = 1;
            @(posedge io_mainClk);

            #1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BufferCC Testbench");
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
        input expected_io_dataOut;
        begin
            if (expected_io_dataOut === (expected_io_dataOut ^ io_dataOut ^ expected_io_dataOut)) begin
                $display("PASS");
                $display("  Outputs: io_dataOut=%b",
                         io_dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_dataOut=%b",
                         expected_io_dataOut);
                $display("  Got:      io_dataOut=%b",
                         io_dataOut);
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
        $dumpvars(0,io_dataIn, io_mainClk, io_dataOut);
    end

endmodule
