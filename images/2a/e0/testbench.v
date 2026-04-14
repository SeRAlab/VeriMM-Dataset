`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A00;
    reg [15:0] A01;
    reg [15:0] A10;
    reg [15:0] A11;
    reg clk;
    reg rst;
    reg valid_in;
    wire [15:0] L00;
    wire [15:0] L01;
    wire [15:0] L10;
    wire [15:0] L11;
    wire [15:0] U00;
    wire [15:0] U01;
    wire [15:0] U10;
    wire [15:0] U11;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .A00(A00),
        .A01(A01),
        .A10(A10),
        .A11(A11),
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .L00(L00),
        .L01(L01),
        .L10(L10),
        .L11(L11),
        .U00(U00),
        .U01(U01),
        .U10(U10),
        .U11(U11),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            A00 = 16'd0;
            A01 = 16'd0;
            A10 = 16'd0;
            A11 = 16'd0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: A = [[2, 1], [4, 3]]", test_num);
            reset_dut();

            A00 = 16'h0002; A01 = 16'h0001;
            A10 = 16'h0004; A11 = 16'h0003;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            wait(valid_out == 1);
            @(posedge clk);


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0002, 16'h0001,
                          16'h0002, 16'h0001, 16'h0000, 16'h0001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: A = [[4, 8], [12, 30]]", test_num);
            reset_dut();

            A00 = 16'h0004; A01 = 16'h0008;
            A10 = 16'h000C; A11 = 16'h001E;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001,
                          16'h0004, 16'h0008, 16'h0000, 16'h0006, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Identity Matrix", test_num);
            reset_dut();

            A00 = 16'h0001; A01 = 16'h0000;
            A10 = 16'h0000; A11 = 16'h0001;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001,
                          16'h0001, 16'h0000, 16'h0000, 16'h0001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Matrix A = [[5, 10], [0, 20]]", test_num);
            reset_dut();

            A00 = 16'h0005; A01 = 16'h000A;
            A10 = 16'h0000; A11 = 16'h0014;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001,
                          16'h0005, 16'h000A, 16'h0000, 16'h0014, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Matrix A = [[3, 6], [9, 20]]", test_num);
            reset_dut();

            A00 = 16'h0003; A01 = 16'h0006;
            A10 = 16'h0009; A11 = 16'h0014;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);

            #1;


            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001,
                          16'h0003, 16'h0006, 16'h0000, 16'h0002, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
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
        input [15:0] expected_L00;
        input [15:0] expected_L01;
        input [15:0] expected_L10;
        input [15:0] expected_L11;
        input [15:0] expected_U00;
        input [15:0] expected_U01;
        input [15:0] expected_U10;
        input [15:0] expected_U11;
        input expected_valid_out;
        begin
            if (expected_L00 === (expected_L00 ^ L00 ^ expected_L00) &&
                expected_L01 === (expected_L01 ^ L01 ^ expected_L01) &&
                expected_L10 === (expected_L10 ^ L10 ^ expected_L10) &&
                expected_L11 === (expected_L11 ^ L11 ^ expected_L11) &&
                expected_U00 === (expected_U00 ^ U00 ^ expected_U00) &&
                expected_U01 === (expected_U01 ^ U01 ^ expected_U01) &&
                expected_U10 === (expected_U10 ^ U10 ^ expected_U10) &&
                expected_U11 === (expected_U11 ^ U11 ^ expected_U11) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: L00=%h, L01=%h, L10=%h, L11=%h, U00=%h, U01=%h, U10=%h, U11=%h, valid_out=%b",
                         L00, L01, L10, L11, U00, U01, U10, U11, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L00=%h, L01=%h, L10=%h, L11=%h, U00=%h, U01=%h, U10=%h, U11=%h, valid_out=%b",
                         expected_L00, expected_L01, expected_L10, expected_L11, expected_U00, expected_U01, expected_U10, expected_U11, expected_valid_out);
                $display("  Got:      L00=%h, L01=%h, L10=%h, L11=%h, U00=%h, U01=%h, U10=%h, U11=%h, valid_out=%b",
                         L00, L01, L10, L11, U00, U01, U10, U11, valid_out);
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
        $dumpvars(0,A00, A01, A10, A11, clk, rst, valid_in, L00, L01, L10, L11, U00, U01, U10, U11, valid_out);
    end

endmodule
