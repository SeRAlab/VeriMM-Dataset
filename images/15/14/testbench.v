`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_a;
    reg [7:0] in_b;
    reg rst;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
        .rst(rst),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_a = 0;
            in_b = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();


            in_a = 8'd10;
            in_b = 8'd20;
            @(posedge clk);


            in_a = 8'd0;
            in_b = 8'd0;


            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();

            in_a = 8'd0;
            in_b = 8'd0;
            @(posedge clk);

            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Boundary Addition (128 + 127)", test_num);
            reset_dut();

            in_a = 8'd128;
            in_b = 8'd127;
            @(posedge clk);

            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Wrap-around Addition (255 + 1)", test_num);
            reset_dut();

            in_a = 8'hFF;
            in_b = 8'h01;
            @(posedge clk);

            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bit Pattern Addition (0xAA + 0x55)", test_num);
            reset_dut();

            in_a = 8'hAA;
            in_b = 8'h55;
            @(posedge clk);

            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
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
        input [7:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,clk, in_a, in_b, rst, result, valid);
    end

endmodule
