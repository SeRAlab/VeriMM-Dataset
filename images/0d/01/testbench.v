`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [4:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .A(A),
        .B(B),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            repeat (3) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            A = 4'd0;
            B = 4'd0;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: A=0, B=0", test_num);
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            A = 4'd5;
            B = 4'd7;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: A=5, B=7", test_num);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            A = 4'd14;
            B = 4'd14;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: A=14, B=14", test_num);
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            A = 4'd15;
            B = 4'd15;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: A=15, B=15 (Overflow Wrap)", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            A = 4'd10;
            B = 4'd2;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: A=10, B=2", test_num);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            A = 4'd1; B = 4'd1;
            @(posedge clk);
            A = 4'd8; B = 4'd8;
            @(posedge clk);

            #1;
            $display("Test %0d: Pipeline Throughput (Checking first data)", test_num);
            #1;

            check_outputs(5'd5);
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
        input [4:0] expected_result;
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
        $dumpvars(0,A, B, clk, result);
    end

endmodule
