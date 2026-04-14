`timescale 1ns/1ps

module neural_network_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] expected_output;
    reg [7:0] input1;
    reg [7:0] input2;
    reg reset;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network dut (
        .clk(clk),
        .expected_output(expected_output),
        .input1(input1),
        .input2(input2),
        .reset(reset),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input1 = 8'd0;
            input2 = 8'd0;
            expected_output = 8'd0;
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
            $display("Test Case %0d: Zero Input Verification", test_num);
            reset_dut();
            input1 = 8'h00;
            input2 = 8'h00;
            expected_output = 8'h00;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Training Convergence to 0x64 (100)", test_num);
            reset_dut();

            input1 = 8'h0A;
            input2 = 8'h14;
            expected_output = 8'd100;


            repeat(100) @(posedge clk);


            #1;



            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Training Convergence to 0xC8 (200)", test_num);
            reset_dut();

            input1 = 8'h20;
            input2 = 8'h20;
            expected_output = 8'd200;

            repeat(150) @(posedge clk);

            #1;


            check_outputs(8'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ReLU Lower Bound Check (Target 0)", test_num);
            reset_dut();


            input1 = 8'h10;
            input2 = 8'h10;
            expected_output = 8'hFF;
            repeat(50) @(posedge clk);


            expected_output = 8'h00;
            repeat(100) @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Sensitivity and Adaptation", test_num);
            reset_dut();


            input1 = 8'd5;
            input2 = 8'd5;
            expected_output = 8'd50;
            repeat(100) @(posedge clk);


            input1 = 8'd25;
            input2 = 8'd25;
            expected_output = 8'd50;
            repeat(100) @(posedge clk);

            #1;


            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_network Testbench");
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
        input [7:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, expected_output, input1, input2, reset, output_signal);
    end

endmodule
