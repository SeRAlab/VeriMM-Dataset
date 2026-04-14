`timescale 1ns/1ps

module serial_to_parallel_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg serial_in;
    wire o_ready;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serial_to_parallel_8bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_in(serial_in),
        .o_ready(o_ready),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            serial_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = 1;
            test_data = 8'hFF;
            $display("Testcase %0d: Sending All Ones (0x%h)", test_num, test_data);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1, test_data);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = 2;
            test_data = 8'h00;
            $display("Testcase %0d: Sending All Zeros (0x%h)", test_num, test_data);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1, test_data);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = 3;
            test_data = 8'hAA;
            $display("Testcase %0d: Sending Alternating Bits (0x%h)", test_num, test_data);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1, test_data);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = 4;
            test_data = 8'h55;
            $display("Testcase %0d: Sending Alternating Bits (0x%h)", test_num, test_data);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1, test_data);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = 5;
            test_data = 8'h3C;
            $display("Testcase %0d: Sending Pattern 0x%h", test_num, test_data);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = test_data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1, test_data);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] test_data;
        begin
            test_num = 6;
            test_data = 8'hA5;
            $display("Testcase %0d: Sending Pattern 0x%h", test_num, test_data);
            reset_dut();

            for (i = 7; i >= 1; i = i - 1) begin
                serial_in = test_data[i];
                @(posedge clk);
            end

            if (o_ready == 0) begin
                serial_in = test_data[0];
                @(posedge clk);
                #2;
                #1;

                check_outputs(1'b1, test_data);
            end else begin
                $display("FAIL: o_ready high too early at bit 7");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serial_to_parallel_8bit Testbench");
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
        input expected_o_ready;
        input [7:0] expected_result;
        begin
            if (expected_o_ready === (expected_o_ready ^ o_ready ^ expected_o_ready) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_ready=%b, result=%h",
                         o_ready, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_ready=%b, result=%h",
                         expected_o_ready, expected_result);
                $display("  Got:      o_ready=%b, result=%h",
                         o_ready, result);
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
        $dumpvars(0,clk, rst_n, serial_in, o_ready, result);
    end

endmodule
