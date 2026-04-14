`timescale 1ns/1ps

module add_sub_overflow_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg Add;
    reg [3:0] B;
    reg Sub;
    reg clk;
    reg reset;
    wire [3:0] O;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_sub_overflow dut (
        .A(A),
        .Add(Add),
        .B(B),
        .Sub(Sub),
        .clk(clk),
        .reset(reset),
        .O(O),
        .V(V)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0;
            B = 4'b0;
            Add = 1'b0;
            Sub = 1'b0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Addition 3 + 2");
            reset_dut();
            A = 4'd3;
            B = 4'd2;
            Add = 1'b1;
            Sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Addition 7 + 1 (Overflow)");
            reset_dut();
            A = 4'sb0111;
            B = 4'sb0001;
            Add = 1'b1;
            Sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Addition -5 + -4 (Overflow)");
            reset_dut();
            A = 4'b1011;
            B = 4'b1100;
            Add = 1'b1;
            Sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Subtraction 5 - 3");
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            Add = 1'b0;
            Sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Subtraction 2 - 5");
            reset_dut();
            A = 4'd2;
            B = 4'd5;
            Add = 1'b0;
            Sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1101, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Subtraction 5 - (-4) (Overflow)");
            reset_dut();
            A = 4'b0101;
            B = 4'b1100;
            Add = 1'b0;
            Sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Subtraction -6 - 3 (Overflow)");
            reset_dut();
            A = 4'b1010;
            B = 4'b0011;
            Add = 1'b0;
            Sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Subtraction -8 - (-8)");
            reset_dut();
            A = 4'b1000;
            B = 4'b1000;
            Add = 1'b0;
            Sub = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Addition 4 + 3");
            reset_dut();
            A = 4'b0100;
            B = 4'b0011;
            Add = 1'b1;
            Sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Addition -4 + -4");
            reset_dut();
            A = 4'b1100;
            B = 4'b1100;
            Add = 1'b1;
            Sub = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_sub_overflow Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_O;
        input expected_V;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: O=%h, V=%b",
                         O, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h, V=%b",
                         expected_O, expected_V);
                $display("  Got:      O=%h, V=%b",
                         O, V);
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
        $dumpvars(0,A, Add, B, Sub, clk, reset, O, V);
    end

endmodule
