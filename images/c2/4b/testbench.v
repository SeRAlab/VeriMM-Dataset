`timescale 1ns/1ps

module binary_max_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [3:0] max;
    wire max_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_max dut (
        .A(A),
        .B(B),
        .clk(clk),
        .max(max),
        .max_sel(max_sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: A > B (A=10, B=5)", test_num);
            A = 4'd10;
            B = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: B > A (A=3, B=12)", test_num);
            A = 4'd3;
            B = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd12, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: A == B (A=8, B=8)", test_num);
            A = 4'd8;
            B = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Both Zero (A=0, B=0)", test_num);
            A = 4'd0;
            B = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Both Max (A=15, B=15)", test_num);
            A = 4'd15;
            B = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: A=15, B=0", test_num);
            A = 4'd15;
            B = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: A=0, B=15", test_num);
            A = 4'd0;
            B = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_max Testbench");
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
        input [3:0] expected_max;
        input expected_max_sel;
        begin
            if (expected_max === (expected_max ^ max ^ expected_max) &&
                expected_max_sel === (expected_max_sel ^ max_sel ^ expected_max_sel)) begin
                $display("PASS");
                $display("  Outputs: max=%h, max_sel=%b",
                         max, max_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h, max_sel=%b",
                         expected_max, expected_max_sel);
                $display("  Got:      max=%h, max_sel=%b",
                         max, max_sel);
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
        $dumpvars(0,A, B, clk, max, max_sel);
    end

endmodule
