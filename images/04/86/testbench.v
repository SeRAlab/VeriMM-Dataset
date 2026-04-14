`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] serial_in;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            serial_in = 2'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            repeat(8) begin
                serial_in = 2'b00;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();
            repeat(8) begin
                serial_in = 2'b11;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Alternating 10-01", test_num);
            reset_dut();
            repeat(4) begin
                serial_in = 2'b10; @(posedge clk);
                serial_in = 2'b01; @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h9999);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Incrementing 2-bit values", test_num);
            reset_dut();


            serial_in = 2'b00; @(posedge clk);
            serial_in = 2'b01; @(posedge clk);
            serial_in = 2'b10; @(posedge clk);
            serial_in = 2'b11; @(posedge clk);
            serial_in = 2'b00; @(posedge clk);
            serial_in = 2'b01; @(posedge clk);
            serial_in = 2'b10; @(posedge clk);
            serial_in = 2'b11; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1B1B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Pattern 0xA5A5", test_num);
            reset_dut();
            serial_in = 2'b10; @(posedge clk);
            serial_in = 2'b10; @(posedge clk);
            serial_in = 2'b01; @(posedge clk);
            serial_in = 2'b01; @(posedge clk);
            serial_in = 2'b10; @(posedge clk);
            serial_in = 2'b10; @(posedge clk);
            serial_in = 2'b01; @(posedge clk);
            serial_in = 2'b01; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Walking Bit (0x0001)", test_num);
            reset_dut();

            repeat(7) begin
                serial_in = 2'b00; @(posedge clk);
            end
            serial_in = 2'b01; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
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
        input [15:0] expected_parallel_out;
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
        $dumpvars(0,clk, rst, serial_in, parallel_out);
    end

endmodule
