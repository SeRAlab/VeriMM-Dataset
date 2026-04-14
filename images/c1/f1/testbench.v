`timescale 1ns/1ps

module sysgen_logical_2d2e86ecb2_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg clr;
    reg d0;
    reg d1;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sysgen_logical_2d2e86ecb2 dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .d0(d0),
        .d1(d1),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            ce = 0;
            d0 = 0;
            d1 = 0;
            @(posedge clk);
            #1;
            clr = 0;
            ce = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 0 AND 0", test_num);
            reset_dut();
            d0 = 0;
            d1 = 0;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 0 AND 1", test_num);
            reset_dut();
            d0 = 0;
            d1 = 1;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 1 AND 0", test_num);
            reset_dut();
            d0 = 1;
            d1 = 0;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 1 AND 1", test_num);
            reset_dut();
            d0 = 1;
            d1 = 1;
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing behavior with clr=1", test_num);
            reset_dut();
            d0 = 1;
            d1 = 1;
            ce = 1;
            clr = 1;
            @(posedge clk);
            #1;





            #1;






            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential transitions 1,1 -> 0,1", test_num);
            reset_dut();
            d0 = 1; d1 = 1;
            @(posedge clk);
            #1;
            d0 = 0; d1 = 1;
            @(posedge clk);
            #1;
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
        $display("sysgen_logical_2d2e86ecb2 Testbench");
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,ce, clk, clr, d0, d1, y);
    end

endmodule
