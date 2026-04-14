`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement1;
    reg [15:0] measurement2;
    reg reset;
    reg [15:0] uncertainty1;
    reg [15:0] uncertainty2;
    wire [15:0] fused_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement1(measurement1),
        .measurement2(measurement2),
        .reset(reset),
        .uncertainty1(uncertainty1),
        .uncertainty2(uncertainty2),
        .fused_position(fused_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement1 = 0;
            measurement2 = 0;
            uncertainty1 = 0;
            uncertainty2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal Uncertainties", test_num);
            reset_dut();
            measurement1 = 16'd100;
            measurement2 = 16'd200;
            uncertainty1 = 16'd50;
            uncertainty2 = 16'd50;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: M1 dominates", test_num);
            reset_dut();
            measurement1 = 16'd100;
            measurement2 = 16'd500;
            uncertainty1 = 16'd10;
            uncertainty2 = 16'd90;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd140);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: M2 dominates", test_num);
            reset_dut();
            measurement1 = 16'd100;
            measurement2 = 16'd500;
            uncertainty1 = 16'd80;
            uncertainty2 = 16'd20;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd420);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero measurements", test_num);
            reset_dut();
            measurement1 = 16'd0;
            measurement2 = 16'd0;
            uncertainty1 = 16'd100;
            uncertainty2 = 16'd100;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values", test_num);
            reset_dut();
            measurement1 = 16'd1000;
            measurement2 = 16'd4000;
            uncertainty1 = 16'd1;
            uncertainty2 = 16'd2;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd2000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Extreme ratio", test_num);
            reset_dut();
            measurement1 = 16'd50;
            measurement2 = 16'd5000;
            uncertainty1 = 16'd1;
            uncertainty2 = 16'd1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd54);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_fused_position;
        begin
            if (expected_fused_position === (expected_fused_position ^ fused_position ^ expected_fused_position)) begin
                $display("PASS");
                $display("  Outputs: fused_position=%h",
                         fused_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fused_position=%h",
                         expected_fused_position);
                $display("  Got:      fused_position=%h",
                         fused_position);
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
        $dumpvars(0,clk, measurement1, measurement2, reset, uncertainty1, uncertainty2, fused_position);
    end

endmodule
