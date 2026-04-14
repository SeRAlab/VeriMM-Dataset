`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] learning_rate;
    reg rst;
    reg [7:0] x_in;
    wire [7:0] x_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .learning_rate(learning_rate),
        .rst(rst),
        .x_in(x_in),
        .x_out(x_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 8'd0;
            learning_rate = 8'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: x=5, learning_rate=1 (Step towards left)", test_num);
            x_in = 8'd5;
            learning_rate = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: x=2, learning_rate=1 (Step towards right)", test_num);
            x_in = 8'd2;
            learning_rate = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: x=3, learning_rate=1 (Already at minimum)", test_num);
            x_in = 8'd3;
            learning_rate = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: x=10, learning_rate=0 (Zero learning rate)", test_num);
            x_in = 8'd10;
            learning_rate = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: x=0, learning_rate=1 (Step from zero)", test_num);
            x_in = 8'd0;
            learning_rate = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd6);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: x=4, learning_rate=1", test_num);
            x_in = 8'd4;
            learning_rate = 8'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd2);
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
        input [7:0] expected_x_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h",
                         x_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h",
                         expected_x_out);
                $display("  Got:      x_out=%h",
                         x_out);
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
        $dumpvars(0,clk, learning_rate, rst, x_in, x_out);
    end

endmodule
