`timescale 1ns/1ps

module binary_to_decimal_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg clk;
    wire [2:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_decimal dut (
        .A(A),
        .clk(clk),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input A = 0 (4'b0000)", test_num);
            reset_dut();
            A = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input A = 1 (4'b0001)", test_num);
            reset_dut();
            A = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input A = 3 (4'b0011)", test_num);
            reset_dut();
            A = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input A = 5 (4'b0101)", test_num);
            reset_dut();
            A = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input A = 7 (4'b0111)", test_num);
            reset_dut();
            A = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            $display("Test %0d: Input A = 8 (4'b1000) - Checking 3-bit truncation/overflow", test_num);
            reset_dut();
            A = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            $display("Test %0d: Input A = 15 (4'b1111) - Checking 3-bit truncation/overflow", test_num);
            reset_dut();
            A = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_decimal Testbench");
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
        input [2:0] expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
        $dumpvars(0,A, clk, X);
    end

endmodule
