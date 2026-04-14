`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] learning_rate;
    reg [7:0] target1;
    reg [7:0] target2;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] weight1_1;
    wire [7:0] weight1_2;
    wire [7:0] weight2_1;
    wire [7:0] weight2_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .clk(clk),
        .learning_rate(learning_rate),
        .target1(target1),
        .target2(target2),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .out1(out1),
        .out2(out2),
        .weight1_1(weight1_1),
        .weight1_2(weight1_2),
        .weight2_1(weight2_1),
        .weight2_2(weight2_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            learning_rate = 0;
            target1 = 0;
            target2 = 0;
            x1 = 0;
            x2 = 0;
            x3 = 0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Initialization", test_num);
            reset_dut();

            learning_rate = 8'h00;
            x1 = 8'h00; x2 = 8'h00; x3 = 8'h00;
            target1 = 8'h00; target2 = 8'h00;

            repeat (2) @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Learning Step", test_num);
            reset_dut();


            learning_rate = 8'h01;
            x1 = 8'h02;
            x2 = 8'h03;
            x3 = 8'h00;
            target1 = 8'h0A;
            target2 = 8'h05;


            @(posedge clk);
            #1;






            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00, 8'h14, 8'h1E, 8'h0A, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Accumulative Learning", test_num);


            learning_rate = 8'h01;
            x1 = 8'h01;
            x2 = 8'h01;
            target1 = 8'h40;
            target2 = 8'h20;



            @(posedge clk);
            #1;






            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h32, 8'h19, 8'h22, 8'h2C, 8'h11, 8'h16);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Learning Rate", test_num);


            reg [7:0] prev_w11, prev_w12, prev_w21, prev_w22;
            prev_w11 = weight1_1; prev_w12 = weight1_2;
            prev_w21 = weight2_1; prev_w22 = weight2_2;

            learning_rate = 8'h00;
            x1 = 8'h05;
            target1 = 8'hFF;

            repeat (2) @(posedge clk);
            #2;


            #1;



            check_outputs(out1, out2, prev_w11, prev_w12, prev_w21, prev_w22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Delta (Wrap)", test_num);
            reset_dut();

            learning_rate = 8'h02;
            x1 = 8'h0A;
            x2 = 8'h00;
            target1 = 8'h20;
            target2 = 8'h00;


            @(posedge clk);
            #1;




            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00, 8'h80, 8'h00, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_network_layer Testbench");
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_weight1_1;
        input [7:0] expected_weight1_2;
        input [7:0] expected_weight2_1;
        input [7:0] expected_weight2_2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_weight1_1 === (expected_weight1_1 ^ weight1_1 ^ expected_weight1_1) &&
                expected_weight1_2 === (expected_weight1_2 ^ weight1_2 ^ expected_weight1_2) &&
                expected_weight2_1 === (expected_weight2_1 ^ weight2_1 ^ expected_weight2_1) &&
                expected_weight2_2 === (expected_weight2_2 ^ weight2_2 ^ expected_weight2_2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, weight1_1=%h, weight1_2=%h, weight2_1=%h, weight2_2=%h",
                         out1, out2, weight1_1, weight1_2, weight2_1, weight2_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, weight1_1=%h, weight1_2=%h, weight2_1=%h, weight2_2=%h",
                         expected_out1, expected_out2, expected_weight1_1, expected_weight1_2, expected_weight2_1, expected_weight2_2);
                $display("  Got:      out1=%h, out2=%h, weight1_1=%h, weight1_2=%h, weight2_1=%h, weight2_2=%h",
                         out1, out2, weight1_1, weight1_2, weight2_1, weight2_2);
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
        $dumpvars(0,clk, learning_rate, target1, target2, x1, x2, x3, out1, out2, weight1_1, weight1_2, weight2_1, weight2_2);
    end

endmodule
