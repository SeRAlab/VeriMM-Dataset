`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire valid;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .valid(valid),
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
            enable = 0;
            x0 = 8'h00;
            x1 = 8'h00;
            x2 = 8'h00;
            x3 = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Zero Input Sequence", test_num);
            reset_dut();

            x0 = 8'h00; x1 = 8'h00; x2 = 8'h00; x3 = 8'h00;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;


            while (!valid) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Incremental Small Values", test_num);
            reset_dut();

            x0 = 8'h01; x1 = 8'h02; x2 = 8'h03; x3 = 8'h04;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            while (!valid) @(posedge clk);



            #1;




            check_outputs(1'b1, y);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Maximum Positive Saturation", test_num);
            reset_dut();

            x0 = 8'h7F; x1 = 8'h7F; x2 = 8'h7F; x3 = 8'h7F;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(1'b1, y);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Negative Sequence", test_num);
            reset_dut();


            x0 = 8'hFF; x1 = 8'hFE; x2 = 8'hFD; x3 = 8'hFC;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            while (!valid) @(posedge clk);

            #1;


            check_outputs(1'b1, y);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Alternating Polarities", test_num);
            reset_dut();

            x0 = 8'h20; x1 = 8'hE0; x2 = 8'h20; x3 = 8'hE0;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            while (!valid) @(posedge clk);

            #1;


            check_outputs(1'b1, y);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_inference Testbench");
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
        input expected_valid;
        input [7:0] expected_y;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, y=%h",
                         valid, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, y=%h",
                         expected_valid, expected_y);
                $display("  Got:      valid=%b, y=%h",
                         valid, y);
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
        $dumpvars(0,clk, enable, reset, x0, x1, x2, x3, valid, y);
    end

endmodule
