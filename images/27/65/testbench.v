`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [15:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 0x1, 0x2, 0x3, 0x4", test_num);
            reset_dut();

            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);

            #2;
            #1;

            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 0xF, 0xF, 0xF, 0xF", test_num);
            reset_dut();

            data_in = 4'hF; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            data_in = 4'hF; @(posedge clk);

            #2;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 0xA, 0x5, 0xA, 0x5", test_num);
            reset_dut();

            data_in = 4'hA; @(posedge clk);
            data_in = 4'h5; @(posedge clk);
            data_in = 4'hA; @(posedge clk);
            data_in = 4'h5; @(posedge clk);

            #2;
            #1;

            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 0x0, 0x0, 0x0, 0x0", test_num);
            reset_dut();

            data_in = 4'h0; @(posedge clk);
            data_in = 4'h0; @(posedge clk);
            data_in = 4'h0; @(posedge clk);
            data_in = 4'h0; @(posedge clk);

            #2;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 3 cycles only (checking ready is low)", test_num);
            reset_dut();

            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);

            #2;



            if (ready === 1'b0) begin
                $display("PASS: Ready is low after 3 cycles");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Ready is high after only 3 cycles");
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
        input [15:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,clk, data_in, rst, data_out, ready);
    end

endmodule
