`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg d_in;
    reg re;
    reg we;
    wire d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .d_in(d_in),
        .re(re),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

        begin
            we = 0;
            d_in = 0;

            @(negedge re);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writing 1, checking output", test_num);
            reset_dut();


            we = 1; d_in = 1;
            @(negedge re);
            we = 0;


            @(posedge re);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writing 0, checking output", test_num);
            reset_dut();


            we = 1; d_in = 0;
            @(negedge re);
            we = 0;


            @(posedge re);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Retention (we=0, changing d_in)", test_num);
            reset_dut();


            we = 1; d_in = 1;
            @(negedge re);
            we = 0;


            d_in = 0;
            #10;


            @(posedge re);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite (1 -> 0)", test_num);
            reset_dut();


            we = 1; d_in = 1;
            @(negedge re);


            we = 1; d_in = 0;
            @(negedge re);
            we = 0;


            @(posedge re);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence over multiple cycles", test_num);
            reset_dut();


            we = 1; d_in = 1;
            @(negedge re);
            we = 0;


            @(posedge re);
            @(negedge re);
            @(posedge re);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%b",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%b",
                         expected_d_out);
                $display("  Got:      d_out=%b",
                         d_out);
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
        $dumpvars(0,d_in, re, we, d_out);
    end

endmodule
