`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [24:0] input_vector;
    reg learn_rate;
    reg rst;
    reg [24:0] target_vector;
    wire [24:0] weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .clk(clk),
        .input_vector(input_vector),
        .learn_rate(learn_rate),
        .rst(rst),
        .target_vector(target_vector),
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
            input_vector = 25'b0;
            target_vector = 25'b0;
            learn_rate = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Neutral State (No Update)", test_num);
            reset_dut();

            input_vector = 25'h0000000;
            target_vector = 25'h0000000;
            learn_rate = 1'b1;

            repeat(10) @(posedge clk);



            #1;




            check_outputs(25'h1084210);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Positive Weight Update", test_num);
            reset_dut();


            input_vector = 25'h0421084;
            target_vector = 25'h2108421;
            learn_rate = 1'b1;

            repeat(10) @(posedge clk);



            #1;




            check_outputs(25'h18C6318);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative Weight Update", test_num);
            reset_dut();


            input_vector = 25'h2108421;
            target_vector = 25'h0421084;
            learn_rate = 1'b1;

            repeat(10) @(posedge clk);



            #1;




            check_outputs(25'h0842104);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Learning Rate Gating (Rate = 0)", test_num);
            reset_dut();

            input_vector = 25'h0421084;
            target_vector = 25'h2108421;
            learn_rate = 1'b0;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(25'h1084210);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Vector Update", test_num);
            reset_dut();


            input_vector  = {5'd10, 5'd20, 5'd05, 5'd08, 5'd15};
            target_vector = {5'd10, 5'd25, 5'd00, 5'd08, 5'd20};
            learn_rate = 1'b1;

            repeat(10) @(posedge clk);



            #1;




            check_outputs(25'h14B0215);
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
        input [24:0] expected_weights;
        begin
            if (expected_weights === (expected_weights ^ weights ^ expected_weights)) begin
                $display("PASS");
                $display("  Outputs: weights=%h",
                         weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weights=%h",
                         expected_weights);
                $display("  Got:      weights=%h",
                         weights);
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
        $dumpvars(0,clk, input_vector, learn_rate, rst, target_vector, weights);
    end

endmodule
