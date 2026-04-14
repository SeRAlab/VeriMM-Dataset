`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cs;
    reg rst_n;
    reg sck;
    reg [31:0] sum;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs(cs),
        .rst_n(rst_n),
        .sck(sck),
        .sum(sum),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        cs = 0;
        forever #5 cs = ~cs;
    end

        task reset_dut;

        begin
            rst_n = 0;
            sck = 0;


            cs = 1;
            sum = 0;
            #20;
            rst_n = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            sum = 32'hAAAAAAAA;
            force cs = 0;
            #10;
            #1;

            check_outputs(1'b1);
            release cs;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            sum = 32'h55555555;
            force cs = 0;
            #10;
            #1;

            check_outputs(1'b0);
            release cs;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            sum = 32'hAAAAAAAA;
            force cs = 0;
            #5;
            sck = 1; #5; sck = 0;
            #5;
            #1;

            check_outputs(1'b0);
            release cs;
        end
        endtask

    task testcase004;

        integer j;
        begin
            test_num = 4;
            reset_dut();
            sum = 32'h00000001;
            force cs = 0;
            #5;
            for (j = 0; j < 31; j = j + 1) begin
                sck = 1; #5; sck = 0; #5;
            end
            #5;
            #1;

            check_outputs(1'b1);
            release cs;
        end
        endtask

    task testcase005;

        integer j;
        begin
            test_num = 5;
            reset_dut();
            sum = 32'hFFFFFFFE;
            force cs = 0;
            #5;
            for (j = 0; j < 31; j = j + 1) begin
                sck = 1; #5; sck = 0; #5;
            end
            #5;
            #1;

            check_outputs(1'b0);
            release cs;
        end
        endtask

    task testcase006;

        integer j;
        begin
            test_num = 6;
            reset_dut();
            sum = 32'hA0000000;
            force cs = 0;
            #5;

            for (j = 0; j < 5; j = j + 1) begin
                sck = 1; #5; sck = 0; #5;
            end
            release cs;
            force cs = 1;
            #20;
            force cs = 0;
            #10;
            #1;

            check_outputs(1'b1);
            release cs;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_miso;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: miso=%b",
                         miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b",
                         expected_miso);
                $display("  Got:      miso=%b",
                         miso);
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
        $dumpvars(0,cs, rst_n, sck, sum, miso);
    end

endmodule
