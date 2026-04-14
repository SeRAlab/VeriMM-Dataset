`timescale 1ns/1ps

module simple_neuron_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] target_output;
    reg [15:0] x1;
    reg [15:0] x2;
    wire [15:0] output_neuron;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_neuron dut (
        .clk(clk),
        .reset(reset),
        .target_output(target_output),
        .x1(x1),
        .x2(x2),
        .output_neuron(output_neuron)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x1 = 16'h0000;
            x2 = 16'h0000;
            target_output = 16'h0000;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs (Midpoint Check)", test_num);
            reset_dut();
            x1 = 16'h0000;
            x2 = 16'h0000;
            target_output = 16'h8000;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'h8000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Inputs (Saturation High)", test_num);
            reset_dut();
            x1 = 16'h7FFF;
            x2 = 16'h7FFF;
            target_output = 16'hFFFF;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Backpropagation Learning Test", test_num);
            reset_dut();
            x1 = 16'h2000;
            x2 = 16'h1000;
            target_output = 16'hA000;


            repeat(50) @(posedge clk);


            #1;



            check_outputs(16'hA000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Inputs (Saturation Low)", test_num);
            reset_dut();

            x1 = 16'h8001;
            x2 = 16'h8001;
            target_output = 16'h0000;

            repeat(10) @(posedge clk);


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
        $display("simple_neuron Testbench");
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
        input [15:0] expected_output_neuron;
        begin
            if (expected_output_neuron === (expected_output_neuron ^ output_neuron ^ expected_output_neuron)) begin
                $display("PASS");
                $display("  Outputs: output_neuron=%h",
                         output_neuron);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_neuron=%h",
                         expected_output_neuron);
                $display("  Got:      output_neuron=%h",
                         output_neuron);
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
        $dumpvars(0,clk, reset, target_output, x1, x2, output_neuron);
    end

endmodule
