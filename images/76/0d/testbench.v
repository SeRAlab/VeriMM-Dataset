`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] ctrl;
    reg [7:0] parallel_in;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .ctrl(ctrl),
        .parallel_in(parallel_in),
        .rst(rst),
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
            ctrl = 2'b00;
            parallel_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Parallel Load");
            reset_dut();
            ctrl = 2'b11;
            parallel_in = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Shift Left (3 times)");
            reset_dut();

            ctrl = 2'b11;
            parallel_in = 8'h01;
            @(posedge clk);

            ctrl = 2'b01;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Shift Right (4 times)");
            reset_dut();

            ctrl = 2'b11;
            parallel_in = 8'hF0;
            @(posedge clk);

            ctrl = 2'b10;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Hold Operation");
            reset_dut();

            ctrl = 2'b11;
            parallel_in = 8'h55;
            @(posedge clk);

            ctrl = 2'b00;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Shift Left Overflow");
            reset_dut();

            ctrl = 2'b11;
            parallel_in = 8'h80;
            @(posedge clk);

            ctrl = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Shift Right Underflow");
            reset_dut();

            ctrl = 2'b11;
            parallel_in = 8'h01;
            @(posedge clk);

            ctrl = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Mixed Sequence (Load -> SL -> SL -> SR)");
            reset_dut();

            ctrl = 2'b11;
            parallel_in = 8'h0F;
            @(posedge clk);

            ctrl = 2'b01;
            @(posedge clk);

            @(posedge clk);

            ctrl = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Load Zero then Shift");
            reset_dut();
            ctrl = 2'b11;
            parallel_in = 8'h00;
            @(posedge clk);
            ctrl = 2'b01;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
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
        $dumpvars(0,clk, ctrl, parallel_in, rst, q);
    end

endmodule
