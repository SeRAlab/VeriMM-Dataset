`timescale 1ns/1ps

module AdaptiveLMSFilter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] error;
    reg reset;
    reg [7:0] step_size;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AdaptiveLMSFilter dut (
        .clk(clk),
        .error(error),
        .reset(reset),
        .step_size(step_size),
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
            $display("\nResetting DUT...");
            reset = 1;
            x = 16'd0;
            error = 8'd0;
            step_size = 8'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Error Stability", test_num);
            reset_dut();

            x = 16'h00FF;
            error = 8'h00;
            step_size = 8'h01;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Weight Adaptation", test_num);
            reset_dut();

            x = 16'h0002;
            error = 8'h01;
            step_size = 8'h01;



            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Weight Adaptation", test_num);
            reset_dut();

            x = 16'h0002;
            error = -8'sd1;
            step_size = 8'h01;



            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step Size Impact", test_num);
            reset_dut();

            x = 16'h0001;
            error = 8'h02;
            step_size = 8'h04;



            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0008);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Update Blocking", test_num);
            reset_dut();

            x = 16'h0000;
            error = 8'h7F;
            step_size = 8'hFF;

            repeat(20) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AdaptiveLMSFilter Testbench");
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
        $dumpvars(0,clk, error, reset, step_size, x, y);
    end

endmodule
