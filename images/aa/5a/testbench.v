`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg rst;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .clk(clk),
        .d(d),
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
            rst = 1;
            d = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset operation check", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in four 1s (1111)", test_num);
            reset_dut();
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 1-0-1-0", test_num);
            reset_dut();
            @(negedge clk) d = 1;
            @(negedge clk) d = 0;
            @(negedge clk) d = 1;
            @(negedge clk) d = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 0-1-1-0", test_num);
            reset_dut();
            @(negedge clk) d = 0;
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(negedge clk) d = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow check (shifting 5 times)", test_num);
            reset_dut();
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(negedge clk) d = 1;
            @(negedge clk) d = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
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
        $dumpvars(0,clk, d, rst, q);
    end

endmodule
