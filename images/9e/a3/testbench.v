`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d_in;
    reg left;
    reg reset;
    reg right;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .d_in(d_in),
        .left(left),
        .reset(reset),
        .right(right),
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
            left = 0;
            right = 0;
            d_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Verify Reset", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            left = 1; right = 1; d_in = 8'hA5;
            @(posedge clk);
            #1;
            $display("Test %0d: Parallel Load (0xA5)", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            left = 1; right = 1; d_in = 8'hFF;
            @(posedge clk);
            #1;

            left = 1; right = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift Left (0xFF -> 0xFE)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            left = 1; right = 1; d_in = 8'hFF;
            @(posedge clk);
            #1;

            left = 0; right = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift Right (0xFF -> 0x7F)", test_num);
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            left = 1; right = 1; d_in = 8'h01;
            @(posedge clk);
            #1;
            left = 1; right = 0;
            repeat(7) @(posedge clk);
            #1;
            $display("Test %0d: Shift Left 7 times (0x01 -> 0x80)", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            left = 1; right = 1; d_in = 8'h80;
            @(posedge clk);
            #1;
            left = 0; right = 1;
            repeat(7) @(posedge clk);
            #1;
            $display("Test %0d: Shift Right 7 times (0x80 -> 0x01)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            left = 1; right = 1; d_in = 8'hAA;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority Check (Reset over Load)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            left = 1; right = 1; d_in = 8'h55;
            @(posedge clk);
            #1;
            left = 0; right = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Hold State (0x55)", test_num);
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d_in, left, reset, right, q);
    end

endmodule
