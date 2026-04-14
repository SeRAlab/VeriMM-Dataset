`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg [15:0] old_position;
    reg reset;
    wire [15:0] new_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .old_position(old_position),
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
        gradient = 16'd0;
        learning_rate = 16'd0;
        old_position = 16'd0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Positive Update", test_num);
        reset_dut();

        old_position = 16'd100;
        learning_rate = 16'd2;
        gradient = 16'd10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd80);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Gradient (No Change)", test_num);
        reset_dut();

        old_position = 16'd500;
        learning_rate = 16'd5;
        gradient = 16'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Learning Rate (No Change)", test_num);
        reset_dut();

        old_position = 16'd1000;
        learning_rate = 16'd0;
        gradient = 16'd50;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Result resulting in negative value (signed wrap)", test_num);
        reset_dut();

        old_position = 16'd10;
        learning_rate = 16'd2;
        gradient = 16'd10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large step update", test_num);
        reset_dut();

        old_position = 16'd10000;
        learning_rate = 16'd100;
        gradient = 16'd50;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'd5000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Behavior Check", test_num);

        old_position = 16'hAAAA;
        learning_rate = 16'h0002;
        gradient = 16'h0002;

        reset = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h0000);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        $dumpvars(0,clk, gradient, learning_rate, old_position, reset, new_position);
    end

endmodule
