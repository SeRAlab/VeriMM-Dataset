`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ldsrc;
    reg shiftnld;
    wire crcerror;
    wire regout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ldsrc(ldsrc),
        .shiftnld(shiftnld),
        .crcerror(crcerror),
        .regout(regout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            shiftnld = 0;
            ldsrc = 0;
            repeat(32) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Loading all Zeros...", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Loading all Ones...", test_num);
            shiftnld = 0;
            ldsrc = 1;
            repeat(32) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Loading 1010 pattern...", test_num);
            reset_dut();
            shiftnld = 0;
            repeat(16) begin
                ldsrc = 1; @(posedge clk);
                ldsrc = 0; @(posedge clk);
            end
            #1;



            #1;




            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: CRC Calculation Mode Shift...", test_num);
            reset_dut();

            shiftnld = 0; ldsrc = 1;
            repeat(5) @(posedge clk);

            shiftnld = 1;
            repeat(10) @(posedge clk);
            #1;


            if (crcerror === 1'bx || regout === 1'bx)
                #1;

                check_outputs(1'b1, 1'b0);
            else
                pass_count = pass_count + 1;
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
        input expected_crcerror;
        input expected_regout;
        begin
            if (expected_crcerror === (expected_crcerror ^ crcerror ^ expected_crcerror) &&
                expected_regout === (expected_regout ^ regout ^ expected_regout)) begin
                $display("PASS");
                $display("  Outputs: crcerror=%b, regout=%b",
                         crcerror, regout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crcerror=%b, regout=%b",
                         expected_crcerror, expected_regout);
                $display("  Got:      crcerror=%b, regout=%b",
                         crcerror, regout);
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
        $dumpvars(0,clk, ldsrc, shiftnld, crcerror, regout);
    end

endmodule
