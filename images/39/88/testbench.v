`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            parallel_in = 8'b0;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task check_sequence;

        input [7:0] expected_val;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                $display("  Checking bit %0d: Expected %b, Got %b", i, expected_val[i], serial_out);
                #1;

                check_outputs(expected_val[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Pattern 10101010", test_num);
            reset_dut();
            parallel_in = 8'b10101010;
            check_sequence(8'b10101010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Pattern 01010101", test_num);
            reset_dut();
            parallel_in = 8'b01010101;
            check_sequence(8'b01010101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Ones 11111111", test_num);
            reset_dut();
            parallel_in = 8'b11111111;
            check_sequence(8'b11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros 00000000", test_num);
            reset_dut();
            parallel_in = 8'b00000000;
            check_sequence(8'b00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Boundary bits 10000001", test_num);
            reset_dut();
            parallel_in = 8'b10000001;
            check_sequence(8'b10000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, parallel_in, reset, serial_out);
    end

endmodule
