`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_in;
    reg shift_left;
    reg shift_right;
    wire [15:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 1;
        parallel_in = 16'h0000;
        shift_left = 0;
        shift_right = 0;
        @(posedge clk);
        #1;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Parallel Load 0xABCD", test_num);
        load = 1;
        parallel_in = 16'hABCD;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Shift Left (0x0001 -> 0x0002)", test_num);

        load = 1;
        parallel_in = 16'h0001;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Shift Right (0x8000 -> 0x4000)", test_num);
        load = 1;
        parallel_in = 16'h8000;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Shift Left 4 times (0x000F -> 0x00F0)", test_num);
        load = 1;
        parallel_in = 16'h000F;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Shift Right 4 times (0xF000 -> 0x0F00)", test_num);
        load = 1;
        parallel_in = 16'hF000;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(16'h0F00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Hold Value (0x5555)", test_num);
        load = 1;
        parallel_in = 16'h5555;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 0;
        shift_right = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Load Priority Check", test_num);

        load = 1;
        parallel_in = 16'h1111;
        @(posedge clk);
        #1;

        load = 1;
        parallel_in = 16'hEEEE;
        shift_left = 1;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 0;
        #1;

        check_outputs(16'hEEEE);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Testcase %0d: Shift Left boundary (0x8000 -> 0x0000)", test_num);
        load = 1;
        parallel_in = 16'h8000;
        @(posedge clk);
        #1;
        load = 0;
        shift_left = 1;
        @(posedge clk);
        #1;
        shift_left = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Testcase %0d: Shift Right boundary (0x0001 -> 0x0000)", test_num);
        load = 1;
        parallel_in = 16'h0001;
        @(posedge clk);
        #1;
        load = 0;
        shift_right = 1;
        @(posedge clk);
        #1;
        shift_right = 0;
        #1;

        check_outputs(16'h0000);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        $dumpvars(0,clk, load, parallel_in, shift_left, shift_right, parallel_out);
    end

endmodule
