`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg j;
    reg k;
    reg r;
    reg reset;
    reg s;
    reg set;
    reg t;
    wire dout;
    wire jkout;
    wire srout;
    wire tout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .j(j),
        .k(k),
        .r(r),
        .reset(reset),
        .s(s),
        .set(set),
        .t(t),
        .dout(dout),
        .jkout(jkout),
        .srout(srout),
        .tout(tout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            set = 0;
            din = 0;
            j = 0;
            k = 0;
            t = 0;
            s = 0;
            r = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            reset = 1; #2;
            #1;

            check_outputs(0, 0, 0, 0);
            reset = 0; #8;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            set = 1; #2;
            #1;

            check_outputs(1, 1, 1, 1);
            set = 0; #8;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            din = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            j = 1; k = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(posedge clk);
            j = 1; k = 0;
            @(posedge clk);

            j = 1; k = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clk);
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(posedge clk);
            s = 1; r = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            @(posedge clk);
            s = 1; r = 0;
            @(posedge clk);

            s = 0; r = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            @(posedge clk);
            din = 1;
            j = 1; k = 0;
            t = 1;
            s = 1; r = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            set = 1;
            reset = 1;
            #2;

            #1;


            check_outputs(0, 0, 0, 0);
            reset = 0; set = 0;
            #8;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_dout;
        input expected_jkout;
        input expected_srout;
        input expected_tout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_jkout === (expected_jkout ^ jkout ^ expected_jkout) &&
                expected_srout === (expected_srout ^ srout ^ expected_srout) &&
                expected_tout === (expected_tout ^ tout ^ expected_tout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b, jkout=%b, srout=%b, tout=%b",
                         dout, jkout, srout, tout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b, jkout=%b, srout=%b, tout=%b",
                         expected_dout, expected_jkout, expected_srout, expected_tout);
                $display("  Got:      dout=%b, jkout=%b, srout=%b, tout=%b",
                         dout, jkout, srout, tout);
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
        $dumpvars(0,clk, din, j, k, r, reset, s, set, t, dout, jkout, srout, tout);
    end

endmodule
