`timescale 1ns/1ps

module cordic_processor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] angle;
    reg clk;
    reg mode;
    reg rst;
    wire [15:0] cosine;
    wire [15:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic_processor dut (
        .angle(angle),
        .clk(clk),
        .mode(mode),
        .rst(rst),
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
            rst = 1;
            angle = 0;
            mode = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Angle 0 Degrees", test_num);
            reset_dut();
            angle = 16'h0000;
            mode = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h4000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Angle 90 Degrees", test_num);
            reset_dut();
            angle = 16'h4000;
            mode = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h4000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Angle -90 Degrees", test_num);
            reset_dut();
            angle = 16'hC000;
            mode = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'hC000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Angle 45 Degrees", test_num);
            reset_dut();
            angle = 16'h2000;
            mode = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h2D41, 16'h2D41);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Angle 30 Degrees", test_num);
            reset_dut();
            angle = 16'h1555;
            mode = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h376D, 16'h2000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Angle -45 Degrees", test_num);
            reset_dut();
            angle = 16'hE000;
            mode = 1'b0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(16'h2D41, 16'hD2BF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic_processor Testbench");
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
        $dumpvars(0,angle, clk, mode, rst, cosine, sine);
    end

endmodule
