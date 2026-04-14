`timescale 1ns/1ps

module pipelined_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .P(P)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 0 x 0", test_num);
            reset_dut();
            A = 8'd0; B = 8'd0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 255 x 255", test_num);
            reset_dut();
            A = 8'hFF; B = 8'hFF;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'hFE01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 12 x 10", test_num);
            reset_dut();
            A = 8'd12; B = 8'd10;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 123 x 1", test_num);
            reset_dut();
            A = 8'd123; B = 8'd1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'd123);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 255 x 0", test_num);
            reset_dut();
            A = 8'hFF; B = 8'd0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 16 x 16", test_num);
            reset_dut();
            A = 8'd16; B = 8'd16;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: 45 x 123", test_num);
            reset_dut();
            A = 8'd45; B = 8'd123;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'h159F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_multiplier Testbench");
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
        input [15:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, rst, P);
    end

endmodule
