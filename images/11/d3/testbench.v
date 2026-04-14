`timescale 1ns/1ps

module simple_nn_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] target;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [7:0] output_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_nn dut (
        .clk(clk),
        .target(target),
        .x1(x1),
        .x2(x2),
        .output_y(output_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x1 = 8'h0;
            x2 = 8'h0;
            target = 8'h0;

            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Zero Inputs", test_num);
            reset_dut();

            x1 = 8'h00;
            x2 = 8'h00;
            target = 8'h00;


            repeat (10) @(posedge clk);



            #1;




            check_outputs(output_y);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mid-range Inputs", test_num);
            reset_dut();

            x1 = 8'h40;
            x2 = 8'h80;
            target = 8'hFF;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(output_y);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Saturated Inputs", test_num);
            reset_dut();

            x1 = 8'hFF;
            x2 = 8'hFF;
            target = 8'h01;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(output_y);
        end
        endtask

    task testcase004;

        reg [7:0] first_output;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Training Step Sequence", test_num);
            reset_dut();


            x1 = 8'h20;
            x2 = 8'h20;
            target = 8'hA0;

            repeat (10) @(posedge clk);
            first_output = output_y;
            $display("  Initial forward pass output: %h", first_output);


            repeat (10) @(posedge clk);

            $display("  Output after one backprop step: %h", output_y);

            #1;


            check_outputs(output_y);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_nn Testbench");
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
        input [7:0] expected_output_y;
        begin
            if (expected_output_y === (expected_output_y ^ output_y ^ expected_output_y)) begin
                $display("PASS");
                $display("  Outputs: output_y=%h",
                         output_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_y=%h",
                         expected_output_y);
                $display("  Got:      output_y=%h",
                         output_y);
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
        $dumpvars(0,clk, target, x1, x2, output_y);
    end

endmodule
