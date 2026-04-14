`timescale 1ns/1ps

module neural_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    wire [15:0] out1;
    wire [15:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_layer dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            in1 <= 8'd0;
            in2 <= 8'd0;
            in3 <= 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            in1 <= 8'h00;
            in2 <= 8'h00;
            in3 <= 8'h00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Unit Inputs", test_num);
            reset_dut();
            in1 <= 8'd1;
            in2 <= 8'd1;
            in3 <= 8'd1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0006, 16'h000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Magnitude Inputs", test_num);
            reset_dut();
            in1 <= 8'd10;
            in2 <= 8'd20;
            in3 <= 8'd30;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h008C, 16'h0140);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Max Inputs", test_num);
            reset_dut();
            in1 <= 8'hFF;
            in2 <= 8'hFF;
            in3 <= 8'hFF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h05FA, 16'h0EF1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Mixed Inputs", test_num);
            reset_dut();
            in1 <= 8'd100;
            in2 <= 8'd0;
            in3 <= 8'd50;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FA, 16'h02BC);
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
        input [15:0] expected_out1;
        input [15:0] expected_out2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
        $dumpvars(0,clk, in1, in2, in3, out1, out2);
    end

endmodule
