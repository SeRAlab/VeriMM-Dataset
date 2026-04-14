`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a11;
    reg [31:0] a12;
    reg [31:0] a21;
    reg [31:0] a22;
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [31:0] q11;
    wire [31:0] q12;
    wire [31:0] q21;
    wire [31:0] q22;
    wire [31:0] r11;
    wire [31:0] r12;
    wire [31:0] r21;
    wire [31:0] r22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .q11(q11),
        .q12(q12),
        .q21(q21),
        .q22(q22),
        .r11(r11),
        .r12(r12),
        .r21(r21),
        .r22(r22)
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
            a11 = 0; a12 = 0; a21 = 0; a22 = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Identity Matrix", test_num);
            a11 = 32'd1; a12 = 32'd0;
            a21 = 32'd0; a22 = 32'd1;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #1;

            check_outputs(1'b1, 32'd1, 32'd0, 32'd0, 32'd1, 32'd1, 32'd0, 32'd0, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Scaled Diagonal", test_num);
            a11 = 32'd3; a12 = 32'd0;
            a21 = 32'd0; a22 = 32'd4;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #1;

            check_outputs(1'b1, 32'd1, 32'd0, 32'd0, 32'd1, 32'd3, 32'd0, 32'd0, 32'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Orthogonal Matrix (Swap)", test_num);
            a11 = 32'd0; a12 = 32'd1;
            a21 = 32'd1; a22 = 32'd0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #1;

            check_outputs(1'b1, 32'd0, 32'd1, 32'd1, 32'd0, 32'd1, 32'd0, 32'd0, 32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Upper Triangular Input", test_num);
            a11 = 32'd2; a12 = 32'd5;
            a21 = 32'd0; a22 = 32'd3;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #1;

            check_outputs(1'b1, 32'd1, 32'd0, 32'd0, 32'd1, 32'd2, 32'd5, 32'd0, 32'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Column Normalization", test_num);
            a11 = 32'd3; a12 = 32'd0;
            a21 = 32'd4; a22 = 32'd5;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);


            if (r21 !== 32'd0) begin
                $display("R21 is not zero - Violation of Upper Triangular property");
            end
            $display("Decomposition completed. Check log for Q and R values.");
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qr_decomposition Testbench");
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
        input expected_done;
        input [31:0] expected_q11;
        input [31:0] expected_q12;
        input [31:0] expected_q21;
        input [31:0] expected_q22;
        input [31:0] expected_r11;
        input [31:0] expected_r12;
        input [31:0] expected_r21;
        input [31:0] expected_r22;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_q11 === (expected_q11 ^ q11 ^ expected_q11) &&
                expected_q12 === (expected_q12 ^ q12 ^ expected_q12) &&
                expected_q21 === (expected_q21 ^ q21 ^ expected_q21) &&
                expected_q22 === (expected_q22 ^ q22 ^ expected_q22) &&
                expected_r11 === (expected_r11 ^ r11 ^ expected_r11) &&
                expected_r12 === (expected_r12 ^ r12 ^ expected_r12) &&
                expected_r21 === (expected_r21 ^ r21 ^ expected_r21) &&
                expected_r22 === (expected_r22 ^ r22 ^ expected_r22)) begin
                $display("PASS");
                $display("  Outputs: done=%b, q11=%h, q12=%h, q21=%h, q22=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         done, q11, q12, q21, q22, r11, r12, r21, r22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, q11=%h, q12=%h, q21=%h, q22=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         expected_done, expected_q11, expected_q12, expected_q21, expected_q22, expected_r11, expected_r12, expected_r21, expected_r22);
                $display("  Got:      done=%b, q11=%h, q12=%h, q21=%h, q22=%h, r11=%h, r12=%h, r21=%h, r22=%h",
                         done, q11, q12, q21, q22, r11, r12, r21, r22);
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
        $dumpvars(0,a11, a12, a21, a22, clk, reset, start, done, q11, q12, q21, q22, r11, r12, r21, r22);
    end

endmodule
