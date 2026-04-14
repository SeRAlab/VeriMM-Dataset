`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] current_weight;
    reg [31:0] input_data;
    reg [31:0] learning_rate;
    reg reset;
    wire [31:0] new_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .current_weight(current_weight),
        .input_data(input_data),
        .learning_rate(learning_rate),
        .reset(reset),
        .new_weight(new_weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_weight = 0;
            input_data = 0;
            learning_rate = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Error", test_num);
            reset_dut();
            current_weight = 32'd100;
            input_data     = 32'd100;
            learning_rate  = 32'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate", test_num);
            reset_dut();
            current_weight = 32'd50;
            input_data     = 32'd100;
            learning_rate  = 32'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Gradient", test_num);
            reset_dut();
            current_weight = 32'd10;
            input_data     = 32'd20;
            learning_rate  = 32'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Gradient", test_num);
            reset_dut();
            current_weight = 32'd50;
            input_data     = 32'd40;
            learning_rate  = 32'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Step Update", test_num);
            reset_dut();
            current_weight = 32'd1000;
            input_data     = 32'd2000;
            learning_rate  = 32'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFDCE8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Starting Weight", test_num);
            reset_dut();
            current_weight = 32'hFFFFFF9C;
            input_data     = 32'd0;
            learning_rate  = 32'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFED4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [31:0] expected_new_weight;
        begin
            if (expected_new_weight === (expected_new_weight ^ new_weight ^ expected_new_weight)) begin
                $display("PASS");
                $display("  Outputs: new_weight=%h",
                         new_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_weight=%h",
                         expected_new_weight);
                $display("  Got:      new_weight=%h",
                         new_weight);
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
        $dumpvars(0,clk, current_weight, input_data, learning_rate, reset, new_weight);
    end

endmodule
