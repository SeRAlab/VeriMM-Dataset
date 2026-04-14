`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    reg start;
    wire [7:0] Q;
    wire [7:0] R;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .start(start),
        .Q(Q),
        .R(R),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        A = 0;
        B = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        A = 8'd20;
        B = 8'd4;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd5, 8'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        A = 8'd17;
        B = 8'd5;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd3, 8'd2, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        A = 8'd5;
        B = 8'd10;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd0, 8'd5, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        A = 8'd255;
        B = 8'd1;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd255, 8'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        A = 8'd255;
        B = 8'd255;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd1, 8'd0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        A = 8'd0;
        B = 8'd50;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd0, 8'd0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        A = 8'd255;
        B = 8'd128;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd1, 8'd127, 1'b1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        A = 8'd200;
        B = 8'd3;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        $display("Testcase %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(8'd66, 8'd2, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("non_restoring_divider Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_Q;
        input [7:0] expected_R;
        input expected_done;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h, done=%b",
                         Q, R, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h, done=%b",
                         expected_Q, expected_R, expected_done);
                $display("  Got:      Q=%h, R=%h, done=%b",
                         Q, R, done);
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
        $dumpvars(0,A, B, clk, reset, start, Q, R, done);
    end

endmodule
