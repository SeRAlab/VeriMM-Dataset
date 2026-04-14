`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            force dut.out = 8'h1;
            @(posedge clk);
            #1;
            release dut.out;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            repeat(1) @(posedge clk);
            #1;
            $display("Testcase %0d: 1 cycle after reset", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase002;

        begin
            reset_dut();


            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: 2 cycles after reset", test_num);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            reset_dut();



            repeat(5) @(posedge clk);
            #1;
            $display("Testcase %0d: 5 cycles after reset", test_num);
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase004;

        begin
            reset_dut();


            repeat(10) @(posedge clk);
            #1;
            $display("Testcase %0d: 10 cycles after reset", test_num);
            #1;

            check_outputs(8'h5C);
        end
        endtask

    task testcase005;

        begin
            reset_dut();



            repeat(20) @(posedge clk);
            #1;
            $display("Testcase %0d: 20 cycles after reset", test_num);
            #1;

            check_outputs(8'h25);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, out);
    end

endmodule
