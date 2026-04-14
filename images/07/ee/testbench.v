`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] operand_a;
    reg [4:0] operand_b;
    reg reset;
    reg start;
    wire done;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .reset(reset),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            operand_a = 0;
            operand_b = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Simple Addition (5 + 3)", test_num);
            reset_dut();

            operand_a = 5'd5;
            operand_b = 5'd3;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum Value Addition with Overflow (31 + 1)", test_num);
            reset_dut();

            operand_a = 5'd31;
            operand_b = 5'd1;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Zero Addition (0 + 0)", test_num);
            reset_dut();

            operand_a = 5'd0;
            operand_b = 5'd0;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Mid-range Addition (15 + 15)", test_num);
            reset_dut();

            operand_a = 5'd15;
            operand_b = 5'd15;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Boundary Addition (16 + 15)", test_num);
            reset_dut();

            operand_a = 5'd16;
            operand_b = 5'd15;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sequence Check (10 + 10)", test_num);
            reset_dut();

            operand_a = 5'd10;
            operand_b = 5'd10;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b1, 5'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input expected_done;
        input [4:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,clk, operand_a, operand_b, reset, start, done, result);
    end

endmodule
