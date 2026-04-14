`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg r;
    reg w;
    wire rw;
    wire w1;
    wire wr;
    wire wr1;
    wire wr1o;
    wire ww;
    wire ww1;
    wire ww1o;
    wire wwr;
    wire wwro;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r(r),
        .w(w),
        .rw(rw),
        .w1(w1),
        .wr(wr),
        .wr1(wr1),
        .wr1o(wr1o),
        .ww(ww),
        .ww1(ww1),
        .ww1o(ww1o),
        .wwr(wwr),
        .wwro(wwro)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            w = 0;
            r = 0;

            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            w = 0;
            r = 0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            w = 1;
            r = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            w = 0;
            r = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            w = 1;
            r = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            w = 1;
            r = 0;
            #2;

            if (rw === 0 && ww === 1) begin

                @(posedge clk);
                #2;
                #1;

                check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
            end else begin
                $display("FAIL: Registration behavior error at testcase005 initial phase");
                fail_count = fail_count + 1;
            end
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
        input expected_rw;
        input expected_w1;
        input expected_wr;
        input expected_wr1;
        input expected_wr1o;
        input expected_ww;
        input expected_ww1;
        input expected_ww1o;
        input expected_wwr;
        input expected_wwro;
        begin
            if (expected_rw === (expected_rw ^ rw ^ expected_rw) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr) &&
                expected_wr1 === (expected_wr1 ^ wr1 ^ expected_wr1) &&
                expected_wr1o === (expected_wr1o ^ wr1o ^ expected_wr1o) &&
                expected_ww === (expected_ww ^ ww ^ expected_ww) &&
                expected_ww1 === (expected_ww1 ^ ww1 ^ expected_ww1) &&
                expected_ww1o === (expected_ww1o ^ ww1o ^ expected_ww1o) &&
                expected_wwr === (expected_wwr ^ wwr ^ expected_wwr) &&
                expected_wwro === (expected_wwro ^ wwro ^ expected_wwro)) begin
                $display("PASS");
                $display("  Outputs: rw=%b, w1=%b, wr=%b, wr1=%b, wr1o=%b, ww=%b, ww1=%b, ww1o=%b, wwr=%b, wwro=%b",
                         rw, w1, wr, wr1, wr1o, ww, ww1, ww1o, wwr, wwro);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rw=%b, w1=%b, wr=%b, wr1=%b, wr1o=%b, ww=%b, ww1=%b, ww1o=%b, wwr=%b, wwro=%b",
                         expected_rw, expected_w1, expected_wr, expected_wr1, expected_wr1o, expected_ww, expected_ww1, expected_ww1o, expected_wwr, expected_wwro);
                $display("  Got:      rw=%b, w1=%b, wr=%b, wr1=%b, wr1o=%b, ww=%b, ww1=%b, ww1o=%b, wwr=%b, wwro=%b",
                         rw, w1, wr, wr1, wr1o, ww, ww1, ww1o, wwr, wwro);
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
        $dumpvars(0,clk, r, w, rw, w1, wr, wr1, wr1o, ww, ww1, ww1o, wwr, wwro);
    end

endmodule
