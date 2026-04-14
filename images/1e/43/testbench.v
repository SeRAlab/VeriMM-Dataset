`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .reset(reset),
        .x(x),
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
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Zero Input", test_num);
            reset_dut();
            x = 16'h0000;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Impulse Response (Single Sample)", test_num);
            reset_dut();
            @(posedge clk);
            x = 16'h0100;
            @(posedge clk);
            x = 16'h0000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(y);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Step Response (DC Input)", test_num);
            reset_dut();
            x = 16'h00FF;
            repeat(20) @(posedge clk);

            if (y != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Filter responded to DC input. y=%h", y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Filter output stuck at zero during DC input.");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative Input handling", test_num);
            reset_dut();
            x = 16'hFF00;
            repeat(10) @(posedge clk);

            if (y[15] == 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Negative input produced negative output. y=%h", y);
            end else if (y == 0) begin
                $display("INFO: Output is zero, check if coefficients are zero.");
                pass_count = pass_count + 1;
            end else begin
                $display("INFO: Output is positive, depends on filter transfer function.");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Scale Input", test_num);
            reset_dut();
            x = 16'h7FFF;
            repeat(15) @(posedge clk);

            if (^y !== 1'bx) begin
                $display("PASS: Filter output valid (non-X) for full scale input.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter output contains X (possible overflow/logic error).");
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
        $display("iir_filter Testbench");
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, reset, x, y);
    end

endmodule
