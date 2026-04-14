`timescale 1ns/1ps

module deserializer_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_8bit dut (
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
            serial_in = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end

            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (8'h00)", test_num);
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (8'hFF)", test_num);
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (8'hAA)", test_num);
            reset_dut();
            send_byte(8'hAA);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (8'h55)", test_num);
            reset_dut();
            send_byte(8'h55);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (8'h80)", test_num);
            reset_dut();
            send_byte(8'h80);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: F0 Pattern (8'hF0)", test_num);
            reset_dut();
            send_byte(8'hF0);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Data (8'hC3)", test_num);
            reset_dut();
            send_byte(8'hC3);
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-process Reset", test_num);
            reset_dut();

            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            serial_in = 1; @(posedge clk);
            reset_dut();
            send_byte(8'h3C);
            #1;

            check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_parallel_out;
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
