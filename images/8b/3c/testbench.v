`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg wclk;
    reg wput;
    reg wq2_rptr;
    reg wrst_n;
    wire wen;
    wire wptr;
    wire wrdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wclk(wclk),
        .wput(wput),
        .wq2_rptr(wq2_rptr),
        .wrst_n(wrst_n),
        .wen(wen),
        .wptr(wptr),
        .wrdy(wrdy)
    );

    // Clock generation (10ns period)
    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk;
    end

        task reset_dut;

        begin
            wrst_n = 0;
            wput = 0;
            wq2_rptr = 0;
            repeat(2) @(posedge wclk);
            #1 wrst_n = 1;
            @(posedge wclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wput = 1;
            wq2_rptr = 0;

            @(posedge wclk);


            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            wput = 1;
            @(posedge wclk);
            #1;

            wput = 1;
            @(posedge wclk);

            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wput = 1;
            @(posedge wclk);
            #1;

            wq2_rptr = 1;
            wput = 0;
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            wput = 1;
            @(posedge wclk);
            #1 wq2_rptr = 1;
            wput = 1;
            #1;
            @(posedge wclk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wput = 0;
            wq2_rptr = 0;
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_wen;
        input expected_wptr;
        input expected_wrdy;
        begin
            if (expected_wen === (expected_wen ^ wen ^ expected_wen) &&
                expected_wptr === (expected_wptr ^ wptr ^ expected_wptr) &&
                expected_wrdy === (expected_wrdy ^ wrdy ^ expected_wrdy)) begin
                $display("PASS");
                $display("  Outputs: wen=%b, wptr=%b, wrdy=%b",
                         wen, wptr, wrdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wen=%b, wptr=%b, wrdy=%b",
                         expected_wen, expected_wptr, expected_wrdy);
                $display("  Got:      wen=%b, wptr=%b, wrdy=%b",
                         wen, wptr, wrdy);
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
        $dumpvars(0,wclk, wput, wq2_rptr, wrst_n, wen, wptr, wrdy);
    end

endmodule
