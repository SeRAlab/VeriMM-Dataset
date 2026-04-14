`timescale 1ns/1ps

module d_ff_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg en;
    reg rst;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_ff dut (
        .clk(clk),
        .d(d),
        .en(en),
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
            en = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Load 1 with EN=1", test_num);
            reset_dut();
            @(negedge clk);
            d = 1;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load 0 with EN=1", test_num);
            reset_dut();

            @(negedge clk);
            d = 1; en = 1;
            @(posedge clk);

            @(negedge clk);
            d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Attempt load 1 with EN=0 (Should stay 0)", test_num);
            reset_dut();
            @(negedge clk);
            d = 1;
            en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold value 1 with EN=0", test_num);
            reset_dut();

            @(negedge clk);
            d = 1; en = 1;
            @(posedge clk);

            @(negedge clk);
            d = 0; en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Asynchronous reset mid-cycle", test_num);
            reset_dut();

            @(negedge clk);
            d = 1; en = 1;
            @(posedge clk);
            #2;

            rst = 1;
            #1;
            #1;

            check_outputs(1'b0);
            #5 rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset priority over active EN/D", test_num);
            reset_dut();
            @(negedge clk);
            d = 1;
            en = 1;
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
            #5 rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_ff Testbench");
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
        $dumpvars(0,clk, d, en, rst, q);
    end

endmodule
