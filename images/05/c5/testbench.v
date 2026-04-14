`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] w0;
    wire [15:0] w1;
    wire [15:0] w2;
    wire [15:0] w3;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .w0(w0),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            x = 0;
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
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Tap Update (w0)", test_num);
            reset_dut();

            x = 16'h0001;
            d = 16'h000A;


            @(posedge clk);
            #1;


            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h000A, 16'h0000, 16'h0000, 16'h0000, 16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-Tap Shifting (w1 update)", test_num);
            reset_dut();


            x = 16'h0001;
            d = 16'h0000;
            @(posedge clk);
            #1;



            x = 16'h0000;
            d = 16'h0005;
            @(posedge clk);
            #1;



            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 16'h0005, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Convergence (Zero Error)", test_num);
            reset_dut();


            x = 16'h0001;
            d = 16'h000A;
            @(posedge clk);
            @(posedge clk);
            #1;


            d = 16'h000A;
            x = 16'h0001;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h000A, 16'h0000, 16'h0000, 16'h0000, 16'h000A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_w0;
        input [15:0] expected_w1;
        input [15:0] expected_w2;
        input [15:0] expected_w3;
        input [15:0] expected_y;
        begin
            if (expected_w0 === (expected_w0 ^ w0 ^ expected_w0) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_w2 === (expected_w2 ^ w2 ^ expected_w2) &&
                expected_w3 === (expected_w3 ^ w3 ^ expected_w3) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w0=%h, w1=%h, w2=%h, w3=%h, y=%h",
                         w0, w1, w2, w3, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w0=%h, w1=%h, w2=%h, w3=%h, y=%h",
                         expected_w0, expected_w1, expected_w2, expected_w3, expected_y);
                $display("  Got:      w0=%h, w1=%h, w2=%h, w3=%h, y=%h",
                         w0, w1, w2, w3, y);
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
        $dumpvars(0,clk, d, reset, x, w0, w1, w2, w3, y);
    end

endmodule
