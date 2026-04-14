`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] expected_output;
    reg [4:0] inputs;
    reg [3:0] learning_rate;
    reg [4:0] weights;
    wire [4:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .clk(clk),
        .expected_output(expected_output),
        .inputs(inputs),
        .learning_rate(learning_rate),
        .weights(weights),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            expected_output = 0;
            inputs = 0;
            learning_rate = 0;
            weights = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: No error calculation", test_num);
            expected_output = 5'd10;
            inputs          = 5'd10;
            learning_rate   = 4'd2;
            weights         = 5'd5;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Positive error, LR=1", test_num);
            expected_output = 5'd15;
            inputs          = 5'd10;
            learning_rate   = 4'd1;
            weights         = 5'd5;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Negative error, LR=1", test_num);
            expected_output = 5'd5;
            inputs          = 5'd10;
            learning_rate   = 4'd1;
            weights         = 5'd20;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Positive error, LR=3", test_num);
            expected_output = 5'd12;
            inputs          = 5'd10;
            learning_rate   = 4'd3;
            weights         = 5'd2;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd8);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Overflow wrap-around", test_num);
            expected_output = 5'd25;
            inputs          = 5'd5;
            learning_rate   = 4'd2;
            weights         = 5'd10;

            @(posedge clk);
            #2;



            #1;




            check_outputs(5'd18);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Zero learning rate", test_num);
            expected_output = 5'd30;
            inputs          = 5'd5;
            learning_rate   = 4'd0;
            weights         = 5'd12;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd12);
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
        input [4:0] expected_updated_weights;
        begin
            if (expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: updated_weights=%h",
                         updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weights=%h",
                         expected_updated_weights);
                $display("  Got:      updated_weights=%h",
                         updated_weights);
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
        $dumpvars(0,clk, expected_output, inputs, learning_rate, weights, updated_weights);
    end

endmodule
