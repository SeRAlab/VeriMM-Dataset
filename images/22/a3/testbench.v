`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] delay;
    reg rst_req;
    wire rst_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .delay(delay),
        .rst_req(rst_req),
        .rst_out(rst_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_req = 0;
            delay = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic operation with delay=5", test_num);
            delay = 4'd5;
            @(posedge clk);
            #1 rst_req = 1;
            @(posedge clk);
            #1 rst_req = 0;

            repeat (6) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Request held high longer than delay=3", test_num);
            delay = 4'd3;
            @(posedge clk);
            #1 rst_req = 1;

            repeat (6) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);

            rst_req = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Minimum delay=1", test_num);
            delay = 4'd1;
            @(posedge clk);
            #1 rst_req = 1;
            @(posedge clk);
            #1 rst_req = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Maximum delay=15", test_num);
            delay = 4'd15;
            @(posedge clk);
            #1 rst_req = 1;
            @(posedge clk);
            #1 rst_req = 0;
            repeat (16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Sequential re-triggering", test_num);


            delay = 4'd2;
            @(posedge clk);
            #1 rst_req = 1;
            repeat(3) @(posedge clk);
            #1 rst_req = 0;
            @(posedge clk);


            delay = 4'd4;
            @(posedge clk);
            #1 rst_req = 1;
            @(posedge clk);
            #1 rst_req = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reset_controller Testbench");
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
        input expected_rst_out;
        begin
            if (expected_rst_out === (expected_rst_out ^ rst_out ^ expected_rst_out)) begin
                $display("PASS");
                $display("  Outputs: rst_out=%b",
                         rst_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst_out=%b",
                         expected_rst_out);
                $display("  Got:      rst_out=%b",
                         rst_out);
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
        $dumpvars(0,clk, delay, rst_req, rst_out);
    end

endmodule
