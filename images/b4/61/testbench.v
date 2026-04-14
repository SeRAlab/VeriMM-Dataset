`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] parallel_data;
    reg rst_n;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .clk(clk),
        .load(load),
        .parallel_data(parallel_data),
        .rst_n(rst_n),
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
        load = 0;
        parallel_data = 4'b0000;
        #15;
        rst_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Parallel Load", test_num);
        reset_dut();
        @(posedge clk);
        load = 1;
        parallel_data = 4'b1010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single Left Shift", test_num);
        reset_dut();

        @(posedge clk);
        load = 1;
        parallel_data = 4'b0011;
        @(posedge clk);

        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Multiple Left Shifts", test_num);
        reset_dut();

        @(posedge clk);
        load = 1;
        parallel_data = 4'b0001;
        @(posedge clk);

        load = 0;
        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Shift until empty", test_num);
        reset_dut();

        @(posedge clk);
        load = 1;
        parallel_data = 4'b1111;
        @(posedge clk);

        load = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Load and consecutive shift", test_num);
        reset_dut();
        @(posedge clk);
        load = 1;
        parallel_data = 4'b0110;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        load = 1;
        parallel_data = 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg Testbench");
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
        $dumpvars(0,clk, load, parallel_data, rst_n, q);
    end

endmodule
