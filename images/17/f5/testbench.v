`timescale 1ns/1ps

module simple_neuron_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] target;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [7:0] bias;
    wire [7:0] output_signal;
    wire [7:0] w1;
    wire [7:0] w2;
    wire [7:0] w3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_neuron dut (
        .clk(clk),
        .reset(reset),
        .target(target),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .bias(bias),
        .output_signal(output_signal),
        .w1(w1),
        .w2(w2),
        .w3(w3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x1 = 0;
            x2 = 0;
            x3 = 0;
            target = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Positive Error Weight Update", test_num);
            reset_dut();

            x1 = 8'h02;
            x2 = 8'h00;
            x3 = 8'h00;
            target = 8'h0A;


            repeat(2) @(posedge clk);






            if (w1 > 8'h00 && bias > 8'h00) begin
                $display("PASS: Weights increased in response to positive error");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weights failed to increase");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Negative Error Weight Update", test_num);
            reset_dut();


            x1 = 8'h01; target = 8'h20;
            repeat(2) @(posedge clk);


            target = 8'h00;
            repeat(2) @(posedge clk);


            if (w1 < 8'h20) begin
                $display("PASS: Weights decreased in response to negative error");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weights failed to decrease");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [7:0] captured_w1;
        begin
            test_num = 4;
            $display("Test Case %0d: Zero Error Stability", test_num);
            reset_dut();


            x1 = 8'h01; target = 8'h05;
            repeat(5) @(posedge clk);


            target = output_signal;
            captured_w1 = w1;

            repeat(2) @(posedge clk);

            if (w1 == captured_w1) begin
                $display("PASS: Weights stable when output == target");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Weights drifted despite zero error");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Multi-input Contribution", test_num);
            reset_dut();


            x1 = 8'h01; x2 = 8'h01; x3 = 8'h01;
            target = 8'h10;
            repeat(2) @(posedge clk);


            if (w1 > 0 && w2 > 0 && w3 > 0) begin
                $display("PASS: All three weight inputs updated");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: One or more weights failed to update");
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
        $display("simple_neuron Testbench");
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
        input [7:0] expected_bias;
        input [7:0] expected_output_signal;
        input [7:0] expected_w1;
        input [7:0] expected_w2;
        input [7:0] expected_w3;
        begin
            if (expected_bias === (expected_bias ^ bias ^ expected_bias) &&
                expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_w2 === (expected_w2 ^ w2 ^ expected_w2) &&
                expected_w3 === (expected_w3 ^ w3 ^ expected_w3)) begin
                $display("PASS");
                $display("  Outputs: bias=%h, output_signal=%h, w1=%h, w2=%h, w3=%h",
                         bias, output_signal, w1, w2, w3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bias=%h, output_signal=%h, w1=%h, w2=%h, w3=%h",
                         expected_bias, expected_output_signal, expected_w1, expected_w2, expected_w3);
                $display("  Got:      bias=%h, output_signal=%h, w1=%h, w2=%h, w3=%h",
                         bias, output_signal, w1, w2, w3);
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
        $dumpvars(0,clk, reset, target, x1, x2, x3, bias, output_signal, w1, w2, w3);
    end

endmodule
