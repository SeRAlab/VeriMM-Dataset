`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] serial_in;
    wire [31:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_in = 8'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential hex values AABBCCDD", test_num);
            reset_dut();

            serial_in = 8'hAA; @(posedge clk);
            serial_in = 8'hBB; @(posedge clk);
            serial_in = 8'hCC; @(posedge clk);
            serial_in = 8'hDD; @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAABBCCDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones FFFFFFFF", test_num);
            reset_dut();
            serial_in = 8'hFF; @(posedge clk);
            serial_in = 8'hFF; @(posedge clk);
            serial_in = 8'hFF; @(posedge clk);
            serial_in = 8'hFF; @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increasing sequence 01020304", test_num);
            reset_dut();
            serial_in = 8'h01; @(posedge clk);
            serial_in = 8'h02; @(posedge clk);
            serial_in = 8'h03; @(posedge clk);
            serial_in = 8'h04; @(posedge clk);
            #1;
            #1;

            check_outputs(32'h01020304);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern 55AA55AA", test_num);
            reset_dut();
            serial_in = 8'h55; @(posedge clk);
            serial_in = 8'hAA; @(posedge clk);
            serial_in = 8'h55; @(posedge clk);
            serial_in = 8'hAA; @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking zero 00000000", test_num);
            reset_dut();
            serial_in = 8'h00; @(posedge clk);
            serial_in = 8'h00; @(posedge clk);
            serial_in = 8'h00; @(posedge clk);
            serial_in = 8'h00; @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out);
    end

endmodule
