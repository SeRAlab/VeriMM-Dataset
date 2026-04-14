`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_in;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            parallel_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();
            parallel_in = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Shift Left", test_num);
            reset_dut();

            parallel_in = 16'h0001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift_left = 1;
            @(posedge clk);
            #1 shift_left = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Single Shift Right", test_num);
            reset_dut();

            parallel_in = 16'h8000;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift_right = 1;
            @(posedge clk);
            #1 shift_right = 0;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Multiple Shift Left (4 positions)", test_num);
            reset_dut();
            parallel_in = 16'h000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1 shift_left = 0;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Shift Right (4 positions)", test_num);
            reset_dut();
            parallel_in = 16'hF000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_right = 1;
            repeat(4) @(posedge clk);
            #1 shift_right = 0;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Shift Left Overflow", test_num);
            reset_dut();
            parallel_in = 16'h8000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            @(posedge clk);
            #1 shift_left = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Shift Right Overflow", test_num);
            reset_dut();
            parallel_in = 16'h0001;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_right = 1;
            @(posedge clk);
            #1 shift_right = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Priority Check (Load over Shift)", test_num);
            reset_dut();
            parallel_in = 16'h5555;
            load = 1;
            shift_left = 1;
            @(posedge clk);
            #1 load = 0; shift_left = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Data Stability (No control active)", test_num);
            reset_dut();
            parallel_in = 16'hAAAA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1;

            check_outputs(16'hAAAA);
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
        testcase010();
        
        
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, load, parallel_in, reset, shift_left, shift_right, q);
    end

endmodule
