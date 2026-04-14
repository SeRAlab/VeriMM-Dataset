`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] phase_in;
    reg rst;
    reg [7:0] shift;
    wire [7:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_in(phase_in),
        .rst(rst),
        .shift(shift),
        .phase_out(phase_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        phase_in = 0;
        shift = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Basic shift (10 + 20)", test_num);
        phase_in = 8'd10;
        shift = 8'd20;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Identity shift (50 + 0)", test_num);
        phase_in = 8'd50;
        shift = 8'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd50);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Boundary wrap-around (255 + 1)", test_num);
        phase_in = 8'd255;
        shift = 8'd1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Large wrap-around (200 + 100)", test_num);
        phase_in = 8'd200;
        shift = 8'd100;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd44);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Maximum shift values (255 + 255)", test_num);
        phase_in = 8'd255;
        shift = 8'd255;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd254);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Zero input max shift (0 + 255)", test_num);
        phase_in = 8'd0;
        shift = 8'd255;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Test %0d: Middle range (128 + 64)", test_num);
        phase_in = 8'd128;
        shift = 8'd64;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd192);
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
        input [7:0] expected_phase_out;
        begin
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%h",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%h",
                         expected_phase_out);
                $display("  Got:      phase_out=%h",
                         phase_out);
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
        $dumpvars(0,clk, phase_in, rst, shift, phase_out);
    end

endmodule
