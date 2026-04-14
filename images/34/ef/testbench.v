`timescale 1ns/1ps

module GradientDescent_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] alpha;
    reg clk;
    reg [15:0] current_position;
    reg reset;
    wire [15:0] new_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GradientDescent dut (
        .alpha(alpha),
        .clk(clk),
        .current_position(current_position),
        .reset(reset),
        .new_position(new_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        alpha = 0;
        current_position = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Basic subtraction (100 - 10)", test_num);
        current_position = 16'd100;
        alpha = 16'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd90);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Zero alpha (500 - 0)", test_num);
        current_position = 16'd500;
        alpha = 16'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Underflow (5 - 10)", test_num);
        current_position = 16'd5;
        alpha = 16'd10;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hFFFB);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Large values (0xFFFF - 0x0001)", test_num);
        current_position = 16'hFFFF;
        alpha = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: High alpha (0x8000 - 0x4000)", test_num);
        current_position = 16'h8000;
        alpha = 16'h4000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Zero position (0 - 1)", test_num);
        current_position = 16'h0000;
        alpha = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Specific gradient step (1000 - 250)", test_num);
        current_position = 16'd1000;
        alpha = 16'd250;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd750);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GradientDescent Testbench");
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
        input [15:0] expected_new_position;
        begin
            if (expected_new_position === (expected_new_position ^ new_position ^ expected_new_position)) begin
                $display("PASS");
                $display("  Outputs: new_position=%h",
                         new_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_position=%h",
                         expected_new_position);
                $display("  Got:      new_position=%h",
                         new_position);
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
        $dumpvars(0,alpha, clk, current_position, reset, new_position);
    end

endmodule
