`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [15:0] step_value;
    wire [15:0] current_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .step_value(step_value),
        .current_level(current_level)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        step_value = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset Verification", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single Increment", test_num);
        reset_dut();
        step_value = 16'd500;
        enable = 1;
        @(posedge clk);
        #1 enable = 0;
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Multiple Accumulations (10 steps)", test_num);
        reset_dut();
        step_value = 16'd100;
        enable = 1;
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
        end
        #1 enable = 0;
        #1;

        check_outputs(16'd1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Enable Signal Toggle", test_num);
        reset_dut();
        step_value = 16'd1000;
        enable = 1;
        @(posedge clk);
        enable = 0;
        @(posedge clk);
        @(posedge clk);
        enable = 1;
        @(posedge clk);
        #1 enable = 0;
        #1;

        check_outputs(16'd2000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Maximum Value Wrap Around", test_num);
        reset_dut();

        step_value = 16'd65530;
        enable = 1;
        @(posedge clk);


        step_value = 16'd10;
        @(posedge clk);

        #1 enable = 0;


        #1;



        check_outputs(16'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Step Value Change", test_num);
        reset_dut();
        enable = 1;
        step_value = 16'd10;
        @(posedge clk);
        @(posedge clk);
        step_value = 16'd5;
        @(posedge clk);
        #1 enable = 0;
        #1;

        check_outputs(16'd25);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
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
        input [15:0] expected_current_level;
        begin
            if (expected_current_level === (expected_current_level ^ current_level ^ expected_current_level)) begin
                $display("PASS");
                $display("  Outputs: current_level=%h",
                         current_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_level=%h",
                         expected_current_level);
                $display("  Got:      current_level=%h",
                         current_level);
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
        $dumpvars(0,clk, enable, reset, step_value, current_level);
    end

endmodule
