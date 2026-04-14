`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    reg serial_in;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            enable = 0;
            serial_in = 0;
            clear = 1;
            #12;
            clear = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic 4-bit shift...");
            test_num = test_num + 1;
            reset_dut();
            enable = 1;


            serial_in = 1; @(posedge clk); #1;
            serial_in = 0; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;


            #1;



            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Enable signal control...");
            test_num = test_num + 1;
            reset_dut();
            enable = 1;

            serial_in = 1; @(posedge clk); #1;
            enable = 0;
            serial_in = 0; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            enable = 1;
            serial_in = 0; @(posedge clk); #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Asynchronous clear...");
            test_num = test_num + 1;
            reset_dut();
            enable = 1;

            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;


            #3 clear = 1;
            #2;

            #1;


            check_outputs(4'b0000);
            clear = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shift-through (5 bits)...");
            test_num = test_num + 1;
            reset_dut();
            enable = 1;


            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 0; @(posedge clk); #1;


            #1;



            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Register hold without enable...");
            test_num = test_num + 1;
            reset_dut();
            enable = 0;

            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;
            serial_in = 1; @(posedge clk); #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clear, clk, enable, serial_in, q);
    end

endmodule
