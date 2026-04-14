`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in1;
    reg [31:0] data_in2;
    reg [2:0] opcode;
    reg rst;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .opcode(opcode),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in1 = 0;
            data_in2 = 0;
            opcode = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_op;

        input [31:0] in1;
        input [31:0] in2;
        input [2:0] op;
        begin
            data_in1 = in1;
            data_in2 = in2;
            opcode = op;
            @(posedge clk);


            repeat(7) @(posedge clk);
            #2;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase001: Addition");
            reset_dut();
            run_op(32'd100, 32'd250, 3'b000);
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Subtraction");
            reset_dut();
            run_op(32'd500, 32'd150, 3'b001);
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Multiplication");
            reset_dut();
            run_op(32'd12, 32'd12, 3'b010);
            #1;

            check_outputs(32'd144);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Division");
            reset_dut();
            run_op(32'd1000, 32'd8, 3'b011);
            #1;

            check_outputs(32'd125);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Negative Subtraction (10 - 20)");
            reset_dut();
            run_op(32'd10, 32'd20, 3'b001);
            #1;

            check_outputs(32'hFFFF_FFF6);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Addition Overflow");
            reset_dut();
            run_op(32'hFFFF_FFFF, 32'd1, 3'b000);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Multiply by Zero");
            reset_dut();
            run_op(32'hA5A5_A5A5, 32'd0, 3'b010);
            #1;

            check_outputs(32'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data_in1, data_in2, opcode, rst, result);
    end

endmodule
