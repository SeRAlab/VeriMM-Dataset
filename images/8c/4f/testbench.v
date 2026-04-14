`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode;
    reg [3:0] parallel_in;
    reg rst_n;
    reg serial_in;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .mode(mode),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        mode = 0;
        parallel_in = 0;
        serial_in = 0;
        #15;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Parallel Load 4'b1010", test_num);
        reset_dut();
        @(negedge clk);
        mode = 0;
        parallel_in = 4'b1010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Serial Shift Right (1 bit, serial_in=1)", test_num);
        reset_dut();
        @(negedge clk);
        mode = 0;
        parallel_in = 4'b1100;
        @(posedge clk);
        @(negedge clk);
        mode = 1;
        serial_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Multiple Serial Shifts (1 -> 0 -> 1)", test_num);
        reset_dut();
        @(negedge clk);
        mode = 1;
        serial_in = 1; @(posedge clk);
        @(negedge clk);
        serial_in = 0; @(posedge clk);
        @(negedge clk);
        serial_in = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Mode Switching (Load -> Shift -> Load)", test_num);
        reset_dut();
        @(negedge clk);
        mode = 0; parallel_in = 4'b0111; @(posedge clk);
        @(negedge clk);
        mode = 1; serial_in = 0; @(posedge clk);
        @(negedge clk);
        mode = 0; parallel_in = 4'b1111; @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Full Shift Out (4 cycles)", test_num);
        reset_dut();
        @(negedge clk);
        mode = 0; parallel_in = 4'b1000; @(posedge clk);
        @(negedge clk);
        mode = 1; serial_in = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Asynchronous Reset Verification", test_num);
        reset_dut();
        @(negedge clk);
        mode = 0; parallel_in = 4'b1111; @(posedge clk);
        #2;
        rst_n = 0;
        #2;
        #1;

        check_outputs(4'b0000);
        rst_n = 1;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, mode, parallel_in, rst_n, serial_in, q);
    end

endmodule
