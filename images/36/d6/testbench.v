`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg [3:0] pin_num;
    reg rst;
    reg rw;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .pin_num(pin_num),
        .rst(rst),
        .rw(rw),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rw = 0;
        pin_num = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset state check...");
        reset_dut();

        pin_num = 4'd7;
        rw = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Write and Read check...");
        reset_dut();

        pin_num = 4'd5;
        rw = 1;
        data_in = 1;
        @(posedge clk);

        #1 rw = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Multiple writes check...");
        reset_dut();

        pin_num = 4'd0; rw = 1; data_in = 1; @(posedge clk);

        #1 pin_num = 4'd15; rw = 1; data_in = 1; @(posedge clk);

        #1 rw = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Overwrite check...");
        reset_dut();

        pin_num = 4'd2; rw = 1; data_in = 1; @(posedge clk);

        #1 pin_num = 4'd2; rw = 1; data_in = 0; @(posedge clk);

        #1 rw = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Pin independence check...");
        reset_dut();

        pin_num = 4'd3; rw = 1; data_in = 1; @(posedge clk);

        #1 pin_num = 4'd4; rw = 1; data_in = 0; @(posedge clk);

        #1 pin_num = 4'd3; rw = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,clk, data_in, pin_num, rst, rw, data_out);
    end

endmodule
