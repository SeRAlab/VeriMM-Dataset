`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control;
    reg rst;
    wire [4:0] sine_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .control(control),
        .rst(rst),
        .sine_out(sine_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            control = 3'b000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            control = 3'b000;
            @(posedge clk);
            #1;
            $display("Test Case 001: 0 degrees");
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            control = 3'b001;
            @(posedge clk);
            #1;
            $display("Test Case 002: 45 degrees");
            #1;

            check_outputs(5'h0B);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            control = 3'b010;
            @(posedge clk);
            #1;
            $display("Test Case 003: 90 degrees");
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            control = 3'b011;
            @(posedge clk);
            #1;
            $display("Test Case 004: 135 degrees");
            #1;

            check_outputs(5'h0B);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            control = 3'b100;
            @(posedge clk);
            #1;
            $display("Test Case 005: 180 degrees");
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            control = 3'b101;
            @(posedge clk);
            #1;
            $display("Test Case 006: 225 degrees");
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            control = 3'b110;
            @(posedge clk);
            #1;
            $display("Test Case 007: 270 degrees");
            #1;

            check_outputs(5'h11);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            control = 3'b111;
            @(posedge clk);
            #1;
            $display("Test Case 008: 315 degrees");
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            rst = 1;
            control = 3'b010;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case 009: Reset behavior");

            #1;


            check_outputs(5'h00);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [4:0] expected_sine_out;
        begin
            if (expected_sine_out === (expected_sine_out ^ sine_out ^ expected_sine_out)) begin
                $display("PASS");
                $display("  Outputs: sine_out=%h",
                         sine_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sine_out=%h",
                         expected_sine_out);
                $display("  Got:      sine_out=%h",
                         sine_out);
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
        $dumpvars(0,clk, control, rst, sine_out);
    end

endmodule
