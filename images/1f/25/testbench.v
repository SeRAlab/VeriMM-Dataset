`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [7:0] instruction;
    reg reset;
    wire [31:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .data_in(data_in),
        .instruction(instruction),
        .reset(reset),
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
            reset = 1;
            data_in = 32'h0;
            instruction = OP_NOP;
            repeat(5) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Simple Addition", test_num);
            reset_dut();

            instruction = OP_ADD;
            data_in = 32'd100;
            @(posedge clk);

            instruction = OP_NOP;
            data_in = 32'd0;

            repeat(7) @(posedge clk);

            #1;


            check_outputs(32'd100, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Simple Subtraction", test_num);
            reset_dut();

            instruction = OP_SUB;
            data_in = 32'd50;
            @(posedge clk);

            instruction = OP_NOP;
            repeat(7) @(posedge clk);

            #1;


            check_outputs(-32'd50, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Multiplication with Accumulation", test_num);
            reset_dut();


            instruction = OP_ADD;
            data_in = 32'd10;
            @(posedge clk);


            instruction = OP_MUL;
            data_in = 32'd5;
            @(posedge clk);

            instruction = OP_NOP;
            repeat(8) @(posedge clk);

            #1;


            check_outputs(32'd50, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Pipeline Throughput (Back-to-back ADDs)", test_num);
            reset_dut();

            instruction = OP_ADD; data_in = 32'd10; @(posedge clk);
            instruction = OP_ADD; data_in = 32'd20; @(posedge clk);
            instruction = OP_ADD; data_in = 32'd30; @(posedge clk);

            instruction = OP_NOP;
            repeat(9) @(posedge clk);

            #1;


            check_outputs(32'd60, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Data Forwarding (SUB then MUL)", test_num);
            reset_dut();

            instruction = OP_ADD; data_in = 32'd100; @(posedge clk);
            instruction = OP_SUB; data_in = 32'd20;  @(posedge clk);
            instruction = OP_MUL; data_in = 32'd2;   @(posedge clk);

            instruction = OP_NOP;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'd160, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Reset During Operation", test_num);
            reset_dut();

            instruction = OP_ADD; data_in = 32'd1000; @(posedge clk);
            instruction = OP_ADD; data_in = 32'd500;  @(posedge clk);

            repeat(3) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat(10) @(posedge clk);



            #1;




            check_outputs(32'd0, 1'b0);
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
        input [31:0] expected_result;
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
        $dumpvars(0,clk, data_in, instruction, reset, result, valid);
    end

endmodule
