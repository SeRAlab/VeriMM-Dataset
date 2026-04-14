`timescale 1ns/1ps

module serial_to_parallel_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg serial_in;
    wire [7:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serial_to_parallel dut (
        .clk(clk),
        .en(en),
        .rst(rst),
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
            rst = 0;
            en = 0;
            serial_in = 0;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
        end
        endtask
    task shift_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                en = 1;
                @(posedge clk);
                #1;
            end
            en = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 0xFF", test_num);
            reset_dut();
            shift_byte(8'hFF);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 0xA5 (10100101)", test_num);
            reset_dut();
            shift_byte(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Gating (Pause shifting)", test_num);
            reset_dut();
            data = 8'h3C;


            for (i = 7; i >= 4; i = i - 1) begin
                serial_in = data[i];
                en = 1;
                @(posedge clk);
                #1;
            end


            en = 0;
            repeat(3) @(posedge clk);
            #1;


            for (i = 3; i >= 0; i = i - 1) begin
                serial_in = data[i];
                en = 1;
                @(posedge clk);
                #1;
            end
            en = 0;

            #1;


            check_outputs(8'h3C, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-back bytes (0x55 then 0xAA)", test_num);
            reset_dut();


            shift_byte(8'h55);
            if (valid !== 1 || parallel_out !== 8'h55) begin
                $display("Sub-test failed: Byte 1 incorrect");
            end


            shift_byte(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                serial_in = 1;
                en = 1;
                @(posedge clk);
            end


            #1 rst = 0;
            @(posedge clk);
            #1 rst = 1;


            shift_byte(8'h0F);
            #1;

            check_outputs(8'h0F, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serial_to_parallel Testbench");
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
        $dumpvars(0,clk, en, rst, serial_in, parallel_out, valid);
    end

endmodule
