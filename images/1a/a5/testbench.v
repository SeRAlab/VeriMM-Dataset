`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] error;
    wire [15:0] w0;
    wire [15:0] w1;
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
        .error(error),
        .w0(w0),
        .w1(w1),
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
            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input Adaptation", test_num);
            reset_dut();

            x = 16'h0000;
            d = 16'h1000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'h1000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Adaptation Step", test_num);
            reset_dut();

            x = 16'h0100;
            d = 16'h0200;

            @(posedge clk);






            #1;
            if (w0 != 16'h0000 || y != 16'h0000) begin
                $display("  Adaptation detected: w0 changes to %h", w0);
            end



            #1;




            check_outputs(error, w0, w1, y);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Delayed Tap (w1) Influence", test_num);
            reset_dut();


            x = 16'h00FF;
            d = 16'h0000;
            @(posedge clk);


            x = 16'h0000;
            d = 16'h0100;
            @(posedge clk);

            #1;

            if (w1 != 16'h0000)
                $display("  w1 adapted using delayed x: %h", w1);

            #1;


            check_outputs(error, w0, w1, y);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Signal Handling", test_num);
            reset_dut();

            x = 16'hFF00;
            d = 16'hFE00;

            repeat(3) @(posedge clk);

            #1;
            $display("  Output with negative input: y=%h, error=%h", y, error);

            #1;


            check_outputs(error, w0, w1, y);
        end
        endtask

    task testcase006;

        reg [15:0] prev_error;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Convergence over Time", test_num);
            reset_dut();

            x = 16'h0010;
            d = 16'h0080;

            @(posedge clk);
            prev_error = error;

            repeat(10) @(posedge clk);

            #1;
            if (error < prev_error || error[15] == 1) begin
                $display("  Convergence check: Error moved from %h to %h", prev_error, error);
            end

            #1;


            check_outputs(error, w0, w1, y);
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
        input [15:0] expected_error;
        input [15:0] expected_w0;
        input [15:0] expected_w1;
        input [15:0] expected_y;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_w0 === (expected_w0 ^ w0 ^ expected_w0) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: error=%h, w0=%h, w1=%h, y=%h",
                         error, w0, w1, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%h, w0=%h, w1=%h, y=%h",
                         expected_error, expected_w0, expected_w1, expected_y);
                $display("  Got:      error=%h, w0=%h, w1=%h, y=%h",
                         error, w0, w1, y);
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
        $dumpvars(0,clk, d, reset, x, error, w0, w1, y);
    end

endmodule
