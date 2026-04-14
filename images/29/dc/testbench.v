`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] coeff0;
    wire [15:0] coeff1;
    wire [15:0] coeff2;
    wire [15:0] coeff3;
    wire [15:0] error;
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
        .coeff0(coeff0),
        .coeff1(coeff1),
        .coeff2(coeff2),
        .coeff3(coeff3),
        .error(error),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            reset = 1;
            x = 16'd0;
            d = 16'd0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Step Adaptation", test_num);
            reset_dut();




            x = 16'd1;
            d = 16'd10;
            @(posedge clk);
            #2;




            #1;





            check_outputs(16'd10, 16'd0, 16'd0, 16'd0, 16'd10, 16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Input Stability", test_num);
            reset_dut();

            x = 16'd0;
            d = 16'd500;
            repeat(5) @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'd500, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multi-Tap Delay Line Propagation", test_num);
            reset_dut();



            x = 16'd1; d = 16'd10; @(posedge clk);
            x = 16'd0; d = 16'd10; @(posedge clk);
            x = 16'd0; d = 16'd10; @(posedge clk);
            x = 16'd0; d = 16'd10; @(posedge clk);
            #2;




            if (coeff0 != 0 && coeff1 != 0 && coeff2 != 0 && coeff3 != 0) begin
                $display("PASS: All coefficients updated via delay line.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: One or more coefficients did not update. Got: c0:%d c1:%d c2:%d c3:%d", coeff0, coeff1, coeff2, coeff3);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [15:0] prev_error;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Convergence Test", test_num);
            reset_dut();

            x = 16'd1;
            d = 16'd100;
            @(posedge clk);
            #2;
            prev_error = error;

            repeat(10) @(posedge clk);
            #2;


            if (error < prev_error) begin
                $display("PASS: Error converged from %d to %d", prev_error, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Error did not decrease. Start: %d, End: %d", prev_error, error);
                fail_count = fail_count + 1;
            end
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
        input [15:0] expected_coeff0;
        input [15:0] expected_coeff1;
        input [15:0] expected_coeff2;
        input [15:0] expected_coeff3;
        input [15:0] expected_error;
        input [15:0] expected_y;
        begin
            if (expected_coeff0 === (expected_coeff0 ^ coeff0 ^ expected_coeff0) &&
                expected_coeff1 === (expected_coeff1 ^ coeff1 ^ expected_coeff1) &&
                expected_coeff2 === (expected_coeff2 ^ coeff2 ^ expected_coeff2) &&
                expected_coeff3 === (expected_coeff3 ^ coeff3 ^ expected_coeff3) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: coeff0=%h, coeff1=%h, coeff2=%h, coeff3=%h, error=%h, y=%h",
                         coeff0, coeff1, coeff2, coeff3, error, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coeff0=%h, coeff1=%h, coeff2=%h, coeff3=%h, error=%h, y=%h",
                         expected_coeff0, expected_coeff1, expected_coeff2, expected_coeff3, expected_error, expected_y);
                $display("  Got:      coeff0=%h, coeff1=%h, coeff2=%h, coeff3=%h, error=%h, y=%h",
                         coeff0, coeff1, coeff2, coeff3, error, y);
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
        $dumpvars(0,clk, d, reset, x, coeff0, coeff1, coeff2, coeff3, error, y);
    end

endmodule
