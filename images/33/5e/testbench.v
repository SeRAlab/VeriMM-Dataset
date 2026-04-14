`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .valid(valid)
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
    task testcase001;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Pattern 0xAA (10101010)", test_num);
            reset_dut();
            data = 8'hAA;

            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end

            #1 #1;
 check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 0x55 (01010101)", test_num);
            reset_dut();
            data = 8'h55;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (0xFF)", test_num);
            reset_dut();
            data = 8'hFF;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (0x00)", test_num);
            reset_dut();
            data = 8'h00;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime-like Pattern (0xA3 / 10100011)", test_num);
            reset_dut();
            data = 8'hA3;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hA3, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Mid-sequence Valid low", test_num);
            reset_dut();
            data = 8'hFF;

            for (i = 7; i >= 4; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end

            #1 #1;
 check_outputs(parallel_out, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking One Pattern (0x08)", test_num);
            reset_dut();
            data = 8'h08;
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h08, 1'b1);
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
        input [7:0] expected_parallel_out;
        input expected_valid;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, valid=%b",
                         parallel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, valid=%b",
                         expected_parallel_out, expected_valid);
                $display("  Got:      parallel_out=%h, valid=%b",
                         parallel_out, valid);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out, valid);
    end

endmodule
