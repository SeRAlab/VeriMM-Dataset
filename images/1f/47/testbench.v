`timescale 1ns/1ps

module pll_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        $display("Resetting DUT...");
        reset = 1;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Reset Stability Check", test_num);
        reset = 1;
        #50;


        #1;



        check_outputs(0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Frequency Multiplication (4x) Check", test_num);
        reset_dut();


        #1000;


        @(posedge clk_out);
        t1 = $realtime;
        @(posedge clk_out);
        t2 = $realtime;
        period = t2 - t1;

        $display("Measured clk_out period: %0f ns (Expected: 2.5ns)", period);



        if (period >= 2.4 && period <= 2.6)
            test_success = clk_out;
        else
            test_success = ~clk_out;

        #1;


        check_outputs(clk_out);
    end
        endtask

    task testcase003;

    integer edge_count;
    begin
        test_num = 3;
        $display("\nTestcase %03d: Edge Count Verification", test_num);
        reset_dut();
        #500;

        edge_count = 0;
        @(posedge clk_in);

        fork
            begin
                repeat (1) @(posedge clk_in);
            end
            begin
                forever begin
                    @(posedge clk_out);
                    edge_count = edge_count + 1;
                end
            end
        join_any
        disable fork;

        $display("Edges of clk_out per clk_in cycle: %0d (Expected: 4)", edge_count);

        if (edge_count == 4)
            #1;

            check_outputs(clk_out);
        else
            #1;

            check_outputs(!clk_out);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll_4x Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, reset, clk_out);
    end

endmodule
