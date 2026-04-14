`timescale 1ns/1ps

module ring_counter_10bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_10bit dut (
        .clk(clk),
        .reset(reset),
        .q(q)
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
            #2;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(10'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #2;

            #1;


            check_outputs(10'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State after 5 clock cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(10'h020);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State after 9 clock cycles (last bit)", test_num);
            reset_dut();
            repeat(9) @(posedge clk);
            #2;

            #1;


            check_outputs(10'h200);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Wraparound after 10 clock cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(10'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple wraparounds (23 cycles)", test_num);
            reset_dut();
            repeat(23) @(posedge clk);
            #2;


            #1;



            check_outputs(10'h008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_10bit Testbench");
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
        input [9:0] expected_q;
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
        $dumpvars(0,clk, reset, q);
    end

endmodule
