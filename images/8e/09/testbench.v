`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aload;
    reg clk;
    reg clrn;
    reg d;
    reg sload;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aload(aload),
        .clk(clk),
        .clrn(clrn),
        .d(d),
        .sload(sload),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clrn = 0;
            aload = 0;
            sload = 0;
            d = 0;
            #15;
            clrn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Clear", test_num);
            reset_dut();

            d = 1;
            sload = 1;
            @(posedge clk);
            #2;

            clrn = 0;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Load High", test_num);
            reset_dut();
            d = 1;
            aload = 1;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Load Low", test_num);
            reset_dut();

            d = 1;
            sload = 1;
            @(posedge clk);
            #2;

            d = 0;
            aload = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Load High", test_num);
            reset_dut();
            @(negedge clk);
            d = 1;
            sload = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Load Low", test_num);
            reset_dut();

            d = 1;
            aload = 1;
            #2;
            aload = 0;

            @(negedge clk);
            d = 0;
            sload = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Priority (clrn vs aload)", test_num);
            reset_dut();
            d = 1;
            aload = 1;
            clrn = 0;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Standard DFF Rising Edge", test_num);
            reset_dut();
            @(negedge clk);
            d = 1;
            sload = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Stability", test_num);
            reset_dut();
            @(negedge clk);
            d = 1;
            sload = 0;
            aload = 0;
            clrn = 1;
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,aload, clk, clrn, d, sload, q);
    end

endmodule
