`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg en;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .areset(areset),
        .clk(clk),
        .en(en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        en = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        @(negedge clk);
        en = 1;
        repeat(5) @(posedge clk);
        #2;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        @(negedge clk);
        en = 1;
        repeat(3) @(posedge clk);
        @(negedge clk);
        en = 0;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        @(negedge clk);
        en = 1;
        repeat(16) @(posedge clk);
        #2;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        @(negedge clk);
        en = 1;
        repeat(2) @(posedge clk);
        en = 0;
        repeat(2) @(posedge clk);
        en = 1;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        @(negedge clk);
        en = 1;
        repeat(8) @(posedge clk);
        #3;
        areset = 1;
        #1;
        #1;

        check_outputs(4'd0);
        areset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        $dumpvars(0,areset, clk, en, q);
    end

endmodule
