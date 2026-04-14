`timescale 1ns/1ps

module nn_backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] target;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [7:0] output_val;
    wire [7:0] weight1;
    wire [7:0] weight2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nn_backpropagation dut (
        .clk(clk),
        .target(target),
        .x1(x1),
        .x2(x2),
        .output_val(output_val),
        .weight1(weight1),
        .weight2(weight2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            target = 0;
            x1 = 0;
            x2 = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Zero Initialization", test_num);
            reset_dut();
            x1 = 8'd0;
            x2 = 8'd0;
            target = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Positive Error Update", test_num);
            reset_dut();
            x1 = 8'd2;
            x2 = 8'd1;
            target = 8'd10;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h14, 8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: High Weight Adjustment (Negative Error)", test_num);
            reset_dut();

            x1 = 8'd2; x2 = 8'd1; target = 8'd10;
            @(posedge clk); @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50, 8'hC4, 8'hE2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Zero Error Stability", test_num);
            reset_dut();

            x1 = 8'd2; x2 = 8'd0; target = 8'd10;
            @(posedge clk); @(posedge clk);


            x1 = 8'd1; x2 = 8'd0; target = 8'd20;
            @(posedge clk); @(posedge clk);
            #1;
            #1;

            check_outputs(8'd20, 8'd20, 8'd00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Boundary Values", test_num);
            reset_dut();
            x1 = 8'd5;
            x2 = 8'd2;
            target = 8'd40;
            @(posedge clk); @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hC8, 8'h50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nn_backpropagation Testbench");
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
        input [7:0] expected_output_val;
        input [7:0] expected_weight1;
        input [7:0] expected_weight2;
        begin
            if (expected_output_val === (expected_output_val ^ output_val ^ expected_output_val) &&
                expected_weight1 === (expected_weight1 ^ weight1 ^ expected_weight1) &&
                expected_weight2 === (expected_weight2 ^ weight2 ^ expected_weight2)) begin
                $display("PASS");
                $display("  Outputs: output_val=%h, weight1=%h, weight2=%h",
                         output_val, weight1, weight2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_val=%h, weight1=%h, weight2=%h",
                         expected_output_val, expected_weight1, expected_weight2);
                $display("  Got:      output_val=%h, weight1=%h, weight2=%h",
                         output_val, weight1, weight2);
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
        $dumpvars(0,clk, target, x1, x2, output_val, weight1, weight2);
    end

endmodule
