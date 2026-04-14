`timescale 1ns/1ps

module DRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d_in;
    reg re;
    reg we;
    wire d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DRAM_Cell dut (
        .clk(clk),
        .d_in(d_in),
        .re(re),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            d_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Write 1 and Read back", test_num);
            reset_dut();


            we = 1;
            d_in = 1;
            @(posedge clk);
            #1 we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write 0 and Read back", test_num);
            reset_dut();


            we = 1;
            d_in = 0;
            @(posedge clk);
            #1 we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Overwrite '1' with '0'", test_num);
            reset_dut();


            we = 1; d_in = 1;
            @(posedge clk);


            #1 d_in = 0;
            @(posedge clk);
            #1 we = 0;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Data Retention with WE/RE low", test_num);
            reset_dut();


            we = 1; d_in = 1;
            @(posedge clk);
            #1 we = 0; d_in = 0;


            repeat(3) @(posedge clk);


            #1 re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: No write when WE is low", test_num);
            reset_dut();


            we = 1; d_in = 0;
            @(posedge clk);
            #1 we = 0;


            we = 0; d_in = 1;
            @(posedge clk);


            #1 re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            re = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Simultaneous Write 1 and Read", test_num);
            reset_dut();


            we = 1; re = 1; d_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
            we = 0; re = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DRAM_Cell Testbench");
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
        $dumpvars(0,clk, d_in, re, we, d_out);
    end

endmodule
