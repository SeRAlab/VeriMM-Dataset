`timescale 1ns/1ps

module fsm_module7_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg p;
    wire w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_module7 dut (
        .clk(clk),
        .p(p),
        .w(w)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            p = 0;


            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic toggle - p sequence [0, 1]", test_num);
            reset_dut();
            p = 0; @(negedge clk);
            p = 1; @(negedge clk);
            #1; #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic toggle - p sequence [1, 0]", test_num);
            reset_dut();
            p = 1; @(negedge clk);
            p = 0; @(negedge clk);
            #1; #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only p=1 - Expect w=0 (Q_nand=0)", test_num);
            reset_dut();
            p = 1; @(negedge clk);
            p = 1; @(negedge clk);
            p = 1; @(negedge clk);
            #1; #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only p=0 - Expect w=0 (Q_or=0)", test_num);
            reset_dut();
            p = 0; @(negedge clk);
            p = 0; @(negedge clk);
            #1; #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Even p=1 pulses - Expect w=0 (Q_xor=0)", test_num);
            reset_dut();
            p = 0; @(negedge clk);
            p = 1; @(negedge clk);
            p = 1; @(negedge clk);
            #1; #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long sequence - Odd parity - Expect w=1", test_num);
            reset_dut();
            p = 0; @(negedge clk);
            p = 1; @(negedge clk);
            p = 0; @(negedge clk);
            p = 1; @(negedge clk);
            p = 1; @(negedge clk);
            #1; #1;
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
        $display("fsm_module7 Testbench");
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
        input expected_w;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%b",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b",
                         expected_w);
                $display("  Got:      w=%b",
                         w);
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
        $dumpvars(0,clk, p, w);
    end

endmodule
