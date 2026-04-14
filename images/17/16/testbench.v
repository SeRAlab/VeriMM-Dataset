`timescale 1ns/1ps

module cordic_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] angle;
    reg clk;
    reg reset;
    wire [15:0] cosine;
    wire [15:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic dut (
        .angle(angle),
        .clk(clk),
        .reset(reset),
        .cosine(cosine),
        .sine(sine)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            angle = 0;
            @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Angle 0 rad", test_num);
            angle = 16'h0000;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(16'h7FFF, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Angle 45 deg (0.7854 rad)", test_num);
            angle = 16'h3244;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(16'h5A82, 16'h5A82);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Angle 90 deg (1.5708 rad)", test_num);
            angle = 16'h6488;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h7FFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Angle -45 deg (-0.7854 rad)", test_num);
            angle = 16'hCDBC;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(16'h5A82, 16'hA57E);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Angle 30 deg (0.5236 rad)", test_num);
            angle = 16'h2183;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(16'h6EDA, 16'h4000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Angle -90 deg (-1.5708 rad)", test_num);
            angle = 16'h9B78;
            repeat (32) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h8001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic Testbench");
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
        input [15:0] expected_cosine;
        input [15:0] expected_sine;
        begin
            if (expected_cosine === (expected_cosine ^ cosine ^ expected_cosine) &&
                expected_sine === (expected_sine ^ sine ^ expected_sine)) begin
                $display("PASS");
                $display("  Outputs: cosine=%h, sine=%h",
                         cosine, sine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cosine=%h, sine=%h",
                         expected_cosine, expected_sine);
                $display("  Got:      cosine=%h, sine=%h",
                         cosine, sine);
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
        $dumpvars(0,angle, clk, reset, cosine, sine);
    end

endmodule
