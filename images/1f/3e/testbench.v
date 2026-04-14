`timescale 1ns/1ps

module neural_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] inputs;
    reg rst;
    reg [3:0] target_outputs;
    wire [3:0] adjusted_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_layer dut (
        .clk(clk),
        .inputs(inputs),
        .rst(rst),
        .target_outputs(target_outputs),
        .adjusted_weights(adjusted_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            inputs = 4'b0000;
            target_outputs = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state with zero signals", test_num);
            reset_dut();
            inputs = 4'b0000;
            target_outputs = 4'b0000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Input, Min Target (High Negative Gradient)", test_num);
            reset_dut();
            inputs = 4'b1111;
            target_outputs = 4'b0000;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Min Input, Max Target (Low Delta)", test_num);
            reset_dut();
            inputs = 4'b0001;
            target_outputs = 4'b1111;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-range signals", test_num);
            reset_dut();
            inputs = 4'b1010;
            target_outputs = 4'b1010;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_layer Testbench");
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
        input [3:0] expected_adjusted_weights;
        begin
            if (expected_adjusted_weights === (expected_adjusted_weights ^ adjusted_weights ^ expected_adjusted_weights)) begin
                $display("PASS");
                $display("  Outputs: adjusted_weights=%h",
                         adjusted_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adjusted_weights=%h",
                         expected_adjusted_weights);
                $display("  Got:      adjusted_weights=%h",
                         adjusted_weights);
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
        $dumpvars(0,clk, inputs, rst, target_outputs, adjusted_weights);
    end

endmodule
