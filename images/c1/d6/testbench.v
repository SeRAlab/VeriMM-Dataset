`timescale 1ns/1ps

module dffr_ns_r1_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dffr_ns_r1 dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            din = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            @(negedge clk);
            rst = 1;
            din = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({SIZE{1'b1}});
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Load Data 0", test_num);
            @(negedge clk);
            rst = 0;
            din = {SIZE{1'b0}};
            @(posedge clk);
            #1;
            #1;

            check_outputs({SIZE{1'b0}});
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Load Data 1", test_num);
            @(negedge clk);
            rst = 0;
            din = {SIZE{1'b1}};
            @(posedge clk);
            #1;
            #1;

            check_outputs({SIZE{1'b1}});
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Reset Priority (rst=1, din=0)", test_num);
            @(negedge clk);
            rst = 1;
            din = {SIZE{1'b0}};
            @(posedge clk);
            #1;
            #1;

            check_outputs({SIZE{1'b1}});
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Multi-cycle Propagation", test_num);
            @(negedge clk);
            rst = 0;
            din = 1'b1;
            @(posedge clk);
            @(negedge clk);
            din = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({SIZE{1'b0}});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dffr_ns_r1 Testbench");
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
        $dumpvars(0,clk, din, rst, q);
    end

endmodule
