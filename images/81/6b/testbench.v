`timescale 1ns/1ps

module edge_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg sig_in;
    wire [7:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_counter dut (
        .clk(clk),
        .rst(rst),
        .sig_in(sig_in),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            sig_in = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic counting (3 edges)", test_num);
            reset_dut();


            @(posedge clk); sig_in = 1;
            repeat(2) @(posedge clk); sig_in = 0;


            repeat(2) @(posedge clk); sig_in = 1;
            repeat(2) @(posedge clk); sig_in = 0;


            repeat(2) @(posedge clk); sig_in = 1;
            repeat(2) @(posedge clk); sig_in = 0;

            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signal held high (1 edge)", test_num);
            reset_dut();

            @(posedge clk); sig_in = 1;
            repeat(10) @(posedge clk);
            sig_in = 0;

            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Rapid pulsing (5 edges)", test_num);
            reset_dut();

            for(i = 0; i < 5; i = i + 1) begin
                @(posedge clk); sig_in = 1;
                @(posedge clk); sig_in = 0;
            end

            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Falling edge test", test_num);
            reset_dut();


            @(posedge clk); sig_in = 1;
            repeat(2) @(posedge clk);


            sig_in = 0;

            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-stream reset", test_num);
            reset_dut();


            repeat(2) begin
                @(posedge clk); sig_in = 1;
                @(posedge clk); sig_in = 0;
            end


            @(posedge clk); rst = 1;
            @(posedge clk); rst = 0;

            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No activity test", test_num);
            reset_dut();

            sig_in = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("edge_counter Testbench");
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
        input [7:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk, rst, sig_in, count_out);
    end

endmodule
