`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] opcode;
    reg reset;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [31:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .opcode(opcode),
        .reset(reset),
        .src1(src1),
        .src2(src2),
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
            opcode = 4'hF;
            src1 = 5'd0;
            src2 = 5'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: ADD Operation (15 + 10)", test_num);
            reset_dut();
            opcode = 4'b0000; src1 = 5'd15; src2 = 5'd10;
            @(posedge clk);
            #1 opcode = 4'hF;

            wait(valid === 1'b1);
            #1;

            check_outputs(32'd25, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: SUB Operation (30 - 12)", test_num);
            reset_dut();
            opcode = 4'b0001; src1 = 5'd30; src2 = 5'd12;
            @(posedge clk);
            #1 opcode = 4'hF;

            wait(valid === 1'b1);
            #1;

            check_outputs(32'd18, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: AND Operation (5'b11011 & 5'b10101)", test_num);
            reset_dut();
            opcode = 4'b0010; src1 = 5'b11011; src2 = 5'b10101;
            @(posedge clk);
            #1 opcode = 4'hF;

            wait(valid === 1'b1);
            #1;

            check_outputs(32'd17, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: OR Operation (5'b10100 | 5'b01011)", test_num);
            reset_dut();
            opcode = 4'b0011; src1 = 5'b10100; src2 = 5'b01011;
            @(posedge clk);
            #1 opcode = 4'hF;

            wait(valid === 1'b1);
            #1;

            check_outputs(32'd31, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: NOT Operation (~5'b00000)", test_num);
            reset_dut();
            opcode = 4'b0100; src1 = 5'b00000; src2 = 5'b00000;
            @(posedge clk);
            #1 opcode = 4'hF;

            wait(valid === 1'b1);

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: NOT Operation (~5'b11111)", test_num);
            reset_dut();
            opcode = 4'b0100; src1 = 5'b11111; src2 = 5'b00000;
            @(posedge clk);
            #1 opcode = 4'hF;

            wait(valid === 1'b1);

            #1;


            check_outputs(32'hFFFFFFE0, 1'b1);
            @(posedge clk);
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
        $dumpvars(0,clk, opcode, reset, src1, src2, result, valid);
    end

endmodule
