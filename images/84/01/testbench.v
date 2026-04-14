`timescale 1ns/1ps

module fibonacci_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [15:0] fib1;
    wire [15:0] fib2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fibonacci_generator dut (
        .clk(clk),
        .reset(reset),
        .fib1(fib1),
        .fib2(fib2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            test_num = 1;
            reset_dut();
            #1;
            #1;

            check_outputs(16'd1, 16'd1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking State after 1 cycle");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1, 16'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking State after 5 cycles");
            test_num = 3;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(16'd8, 16'd13);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking State after 10 cycles");
            test_num = 4;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd89, 16'd144);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking State after 20 cycles");
            test_num = 5;
            reset_dut();
            repeat(20) @(posedge clk);
            #1;


            #1;



            check_outputs(16'd10946, 16'd17711);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking State after 22 cycles");
            test_num = 6;
            reset_dut();
            repeat(22) @(posedge clk);
            #1;


            #1;



            check_outputs(16'd28657, 16'd46368);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fibonacci_generator Testbench");
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
        input [15:0] expected_fib1;
        input [15:0] expected_fib2;
        begin
            if (expected_fib1 === (expected_fib1 ^ fib1 ^ expected_fib1) &&
                expected_fib2 === (expected_fib2 ^ fib2 ^ expected_fib2)) begin
                $display("PASS");
                $display("  Outputs: fib1=%h, fib2=%h",
                         fib1, fib2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fib1=%h, fib2=%h",
                         expected_fib1, expected_fib2);
                $display("  Got:      fib1=%h, fib2=%h",
                         fib1, fib2);
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
        $dumpvars(0,clk, reset, fib1, fib2);
    end

endmodule
