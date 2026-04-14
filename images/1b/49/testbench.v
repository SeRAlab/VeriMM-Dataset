`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_in;
    reg rst;
    reg shift_left;
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
        .rst(rst),
        .shift_left(shift_left),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            parallel_in = 16'b0;
            shift_left = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parallel Load", test_num);
            reset_dut();
            parallel_in = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left (1 bit)", test_num);
            reset_dut();

            parallel_in = 16'h0001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift_left = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right (1 bit)", test_num);
            reset_dut();

            parallel_in = 16'h8000;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            shift_left = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Shift Lefts (4 bits)", test_num);
            reset_dut();
            parallel_in = 16'h000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Shift Rights (4 bits)", test_num);
            reset_dut();
            parallel_in = 16'hF000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left until empty", test_num);
            reset_dut();
            parallel_in = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load priority over Shift", test_num);
            reset_dut();

            parallel_in = 16'h1111;
            load = 1;
            @(posedge clk);
            #1;

            parallel_in = 16'hBBBB;
            load = 1;
            shift_left = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBBBB);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right Continuous (Verify zero filling)", test_num);
            reset_dut();
            parallel_in = 16'h00FF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift_left = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Load/Shift sequence", test_num);
            reset_dut();

            parallel_in = 16'h1234;
            load = 1;
            @(posedge clk); #1 load = 0;

            shift_left = 1;
            repeat(2) @(posedge clk); #1;

            shift_left = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h2468);
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
        $dumpvars(0,clk, load, parallel_in, rst, shift_left, q);
    end

endmodule
