`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg deqEn;
    reg enqEn;
    reg enqVal;
    reg rst_n;
    wire deqRdy;
    wire deqVal;
    wire enqRdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .deqEn(deqEn),
        .enqEn(enqEn),
        .enqVal(enqVal),
        .rst_n(rst_n),
        .deqRdy(deqRdy),
        .deqVal(deqVal),
        .enqRdy(enqRdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enqEn = 0;
            deqEn = 0;
            enqVal = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'bx, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Enqueue High", test_num);
            reset_dut();


            if (enqRdy) begin
                enqEn = 1;
                enqVal = 1;
                @(posedge clk);
                #1;
                enqEn = 0;
            end


            #1;



            check_outputs(1'b1, 1'b1, 1'bx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Enqueue Low", test_num);
            reset_dut();


            if (enqRdy) begin
                enqEn = 1;
                enqVal = 0;
                @(posedge clk);
                #1;
                enqEn = 0;
            end


            #1;



            check_outputs(1'b1, 1'b0, 1'bx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Enqueue and Dequeue", test_num);
            reset_dut();


            enqEn = 1; enqVal = 1;
            @(posedge clk);
            #1;


            enqEn = 0;
            if (deqRdy) begin
                deqEn = 1;
                @(posedge clk);
                #1;
                deqEn = 0;
            end


            #1;



            check_outputs(1'b0, 1'bx, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: FIFO Ordering Check", test_num);
            reset_dut();


            enqEn = 1; enqVal = 1;
            @(posedge clk); #1;

            enqEn = 1; enqVal = 0;
            @(posedge clk); #1;
            enqEn = 0;



            #1;




            check_outputs(1'b1, 1'b1, 1'bx);
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
        input expected_deqRdy;
        input expected_deqVal;
        input expected_enqRdy;
        begin
            if (expected_deqRdy === (expected_deqRdy ^ deqRdy ^ expected_deqRdy) &&
                expected_deqVal === (expected_deqVal ^ deqVal ^ expected_deqVal) &&
                expected_enqRdy === (expected_enqRdy ^ enqRdy ^ expected_enqRdy)) begin
                $display("PASS");
                $display("  Outputs: deqRdy=%b, deqVal=%b, enqRdy=%b",
                         deqRdy, deqVal, enqRdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deqRdy=%b, deqVal=%b, enqRdy=%b",
                         expected_deqRdy, expected_deqVal, expected_enqRdy);
                $display("  Got:      deqRdy=%b, deqVal=%b, enqRdy=%b",
                         deqRdy, deqVal, enqRdy);
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
        $dumpvars(0,clk, deqEn, enqEn, enqVal, rst_n, deqRdy, deqVal, enqRdy);
    end

endmodule
