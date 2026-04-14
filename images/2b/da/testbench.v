`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] X1;
    reg [7:0] X2;
    reg [7:0] Y1;
    reg [7:0] Y2;
    reg clk;
    reg rst_n;
    wire [7:0] X3;
    wire [7:0] Y3;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .X1(X1),
        .X2(X2),
        .Y1(Y1),
        .Y2(Y2),
        .clk(clk),
        .rst_n(rst_n),
        .X3(X3),
        .Y3(Y3),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        X1 = 0; Y1 = 0; X2 = 0; Y2 = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        X1 = 8'd5; Y1 = 8'd1; X2 = 8'd6; Y2 = 8'd3;
        test_num = test_num + 1;
        $display("Test Case %0d: Standard Addition (5,1) + (6,3)", test_num);
        wait(valid);
        @(posedge clk);
        #1;

        check_outputs(8'd10, 8'd6, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        X1 = 8'd5; Y1 = 8'd1; X2 = 8'd5; Y2 = 8'd1;
        test_num = test_num + 1;
        $display("Test Case %0d: Point Doubling 2*(5,1)", test_num);
        wait(valid);
        @(posedge clk);
        #1;

        check_outputs(8'd6, 8'd3, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        X1 = 8'd5; Y1 = 8'd1; X2 = 8'd5; Y2 = 8'd16;
        test_num = test_num + 1;
        $display("Test Case %0d: Additive Inverse (5,1) + (5,16)", test_num);
        wait(valid);
        @(posedge clk);
        #1;

        check_outputs(8'd0, 8'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        X1 = 8'd10; Y1 = 8'd6; X2 = 8'd0; Y2 = 8'd0;
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Property (10,6) + (0,0)", test_num);
        wait(valid);
        @(posedge clk);
        #1;

        check_outputs(8'd10, 8'd6, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ECC_Point_Addition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_X3;
        input [7:0] expected_Y3;
        input expected_valid;
        begin
            if (expected_X3 === (expected_X3 ^ X3 ^ expected_X3) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: X3=%h, Y3=%h, valid=%b",
                         X3, Y3, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X3=%h, Y3=%h, valid=%b",
                         expected_X3, expected_Y3, expected_valid);
                $display("  Got:      X3=%h, Y3=%h, valid=%b",
                         X3, Y3, valid);
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
        $dumpvars(0,X1, X2, Y1, Y2, clk, rst_n, X3, Y3, valid);
    end

endmodule
