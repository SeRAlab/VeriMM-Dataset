`timescale 1ns/1ps

module add_sub_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg ctrl;
    reg reset;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_sub_4bit dut (
        .A(A),
        .B(B),
        .clk(clk),
        .ctrl(ctrl),
        .reset(reset),
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
            A = 0;
            B = 0;
            ctrl = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            ctrl = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 5 + 3", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd12;
            B = 4'd5;
            ctrl = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 12 + 5 (Overflow/Wrap)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd7;
            B = 4'd7;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 7 - 7", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd3;
            B = 4'd5;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 3 - 5 (Underflow/Wrap)", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'hf;
            B = 4'hf;
            ctrl = 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Max Addition 15 + 15", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd0;
            B = 4'd1;
            ctrl = 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 0 - 1", test_num);
            #1;

            check_outputs(4'hf);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_sub_4bit Testbench");
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
        input [3:0] expected_result;
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
        $dumpvars(0,A, B, clk, ctrl, reset, result);
    end

endmodule
