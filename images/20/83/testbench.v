`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Simple Addition", test_num);
            @(posedge clk);
            A <= 8'd10;
            B <= 8'd20;


            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Zero Inputs", test_num);
            @(posedge clk);
            A <= 8'd0;
            B <= 8'd0;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: High boundary (No overflow)", test_num);
            @(posedge clk);
            A <= 8'd125;
            B <= 8'd125;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Stage 1 Overflow", test_num);
            @(posedge clk);
            A <= 8'd250;
            B <= 8'd10;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd9);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Stage 2 Overflow", test_num);
            @(posedge clk);
            A <= 8'd125;
            B <= 8'd127;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Extreme Overflow", test_num);
            @(posedge clk);
            A <= 8'hFF;
            B <= 8'hFF;

            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'd3);
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
        input [7:0] expected_S;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
        $dumpvars(0,A, B, clk, rst, S);
    end

endmodule
