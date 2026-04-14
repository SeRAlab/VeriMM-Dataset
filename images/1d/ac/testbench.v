`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg re;
    reg we;
    wire [2:0] count;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .re(re),
        .we(we),
        .count(count),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            re = 1;
            data_in = 0;
            repeat(5) @(posedge clk);
            re = 0;
            @(posedge clk);
            $display("--- DUT Reset/Drained ---");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Write", test_num);
            reset_dut();
            data_in = 4'hA;
            we = 1;
            @(posedge clk);
            we = 0;
            #1;
            #1;

            check_outputs(3'd1, 4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill Capacity (Depth 4)", test_num);
            reset_dut();
            we = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            we = 0;
            #1;
            #1;

            check_outputs(3'd4, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Protection", test_num);
            reset_dut();
            we = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            we = 0;
            #1;
            #1;

            check_outputs(3'd4, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Sequence", test_num);
            reset_dut();
            we = 1;
            data_in = 4'h5; @(posedge clk);
            data_in = 4'h6; @(posedge clk);
            data_in = 4'h7; @(posedge clk);
            we = 0;
            re = 1;
            @(posedge clk);
            @(posedge clk);
            re = 0;
            #1;
            #1;

            check_outputs(3'd1, 4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow/Empty Check", test_num);
            reset_dut();
            re = 1;
            @(posedge clk);
            re = 0;
            #1;
            #1;

            check_outputs(3'd0, 4'hx);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();

            we = 1; data_in = 4'hB; @(posedge clk);

            we = 1; re = 1; data_in = 4'hC; @(posedge clk);
            we = 0; re = 0;
            #1;
            #1;

            check_outputs(3'd1, 4'hC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Drain to Empty", test_num);
            reset_dut();
            we = 1; data_in = 4'h9; @(posedge clk);
            we = 0; re = 1; @(posedge clk);
            re = 0;
            #1;
            #1;

            check_outputs(3'd0, 4'hx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [2:0] expected_count;
        input [3:0] expected_data_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%h",
                         count, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%h",
                         expected_count, expected_data_out);
                $display("  Got:      count=%h, data_out=%h",
                         count, data_out);
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
        $dumpvars(0,clk, data_in, re, we, count, data_out);
    end

endmodule
