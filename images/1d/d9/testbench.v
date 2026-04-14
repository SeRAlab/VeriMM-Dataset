`timescale 1ns/1ps

module deserializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg serial_in;
    wire data_ready;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_16bit dut (
        .clk(clk),
        .serial_in(serial_in),
        .data_ready(data_ready),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            serial_in = 0;



            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task shift_16_bits;

        input [15:0] data;
        integer i;
        begin
            for (i = 15; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end


            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros (16'h0000)");
            reset_dut();
            shift_16_bits(16'h0000);
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All Ones (16'hFFFF)");
            reset_dut();
            shift_16_bits(16'hFFFF);
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Alternating bits (16'hAAAA)");
            reset_dut();
            shift_16_bits(16'hAAAA);
            #1;

            check_outputs(1'b1, 16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Alternating bits (16'h5555)");
            reset_dut();
            shift_16_bits(16'h5555);
            #1;

            check_outputs(1'b1, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Hex Pattern (16'h1234)");
            reset_dut();
            shift_16_bits(16'h1234);
            #1;

            check_outputs(1'b1, 16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Walking Bit (16'h8001)");
            reset_dut();
            shift_16_bits(16'h8001);
            #1;

            check_outputs(1'b1, 16'h8001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_16bit Testbench");
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
        input expected_data_ready;
        input [15:0] expected_parallel_out;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, parallel_out=%h",
                         data_ready, parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, parallel_out=%h",
                         expected_data_ready, expected_parallel_out);
                $display("  Got:      data_ready=%b, parallel_out=%h",
                         data_ready, parallel_out);
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
        $dumpvars(0,clk, serial_in, data_ready, parallel_out);
    end

endmodule
