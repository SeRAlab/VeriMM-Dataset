`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg clk;
    wire [8:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .A(A),
        .B(B),
        .C(C),
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
        C = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case %03d: Simple addition (10 + 20 + 5)", test_num);
        A = 8'd10;
        B = 8'd20;
        C = 8'd5;

        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'd35);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case %03d: Large values (200 + 200 + 100)", test_num);
        A = 8'd200;
        B = 8'd200;
        C = 8'd100;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'd500);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case %03d: All zeros", test_num);
        A = 8'd0;
        B = 8'd0;
        C = 8'd0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case %03d: Boundary check (255 + 255 + 1)", test_num);
        A = 8'd255;
        B = 8'd255;
        C = 8'd1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'd511);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case %03d: Overflow check (255 + 255 + 255)", test_num);
        A = 8'd255;
        B = 8'd255;
        C = 8'd255;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(9'd253);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_adder Testbench");
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
        input [8:0] expected_result;
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
        $dumpvars(0,A, B, C, clk, result);
    end

endmodule
