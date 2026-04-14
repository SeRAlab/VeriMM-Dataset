`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] expected_output;
    reg [7:0] input_vector;
    reg rst;
    wire [7:0] bias;
    wire [7:0] weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .clk(clk),
        .expected_output(expected_output),
        .input_vector(input_vector),
        .rst(rst),
        .bias(bias),
        .weights(weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            expected_output = 8'd0;
            input_vector = 8'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Positive Gradient (Expected High)", test_num);
            reset_dut();

            input_vector = 8'h20;
            expected_output = 8'hFF;


            repeat(5) @(posedge clk);



            #1;




            check_outputs(8'h0A, 8'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Negative Gradient (Expected Low)", test_num);
            reset_dut();

            input_vector = 8'h40;
            expected_output = 8'h00;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'hF0, 8'hE0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Zero Input Vector", test_num);
            reset_dut();

            input_vector = 8'h00;
            expected_output = 8'hFF;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h0A, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Convergence Near Midpoint", test_num);
            reset_dut();

            input_vector = 8'h05;
            expected_output = 8'h80;

            repeat(5) @(posedge clk);



            #1;




            check_outputs(8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("backpropagation Testbench");
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
        input [7:0] expected_weights;
        begin
            if (expected_bias === (expected_bias ^ bias ^ expected_bias) &&
                expected_weights === (expected_weights ^ weights ^ expected_weights)) begin
                $display("PASS");
                $display("  Outputs: bias=%h, weights=%h",
                         bias, weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bias=%h, weights=%h",
                         expected_bias, expected_weights);
                $display("  Got:      bias=%h, weights=%h",
                         bias, weights);
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
        $dumpvars(0,clk, expected_output, input_vector, rst, bias, weights);
    end

endmodule
