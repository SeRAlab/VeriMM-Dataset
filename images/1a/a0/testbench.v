`timescale 1ns/1ps

module cholesky_decomposition_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a22;
    reg clk;
    reg rst;
    wire done;
    wire [15:0] l11;
    wire [15:0] l12;
    wire [15:0] l22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cholesky_decomposition dut (
        .a11(a11),
        .a12(a12),
        .a22(a22),
        .clk(clk),
        .rst(rst),
        .done(done),
        .l11(l11),
        .l12(l12),
        .l22(l22)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a11 = 0;
            a12 = 0;
            a22 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Identity Matrix");
            test_num = test_num + 1;
            reset_dut();
            a11 = 16'd1; a12 = 16'd0; a22 = 16'd1;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd1, 16'd0, 16'd1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Simple Integer Decomposition");
            test_num = test_num + 1;
            reset_dut();
            a11 = 16'd4; a12 = 16'd6; a22 = 16'd13;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd2, 16'd3, 16'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Larger Squares");
            test_num = test_num + 1;
            reset_dut();
            a11 = 16'd64; a12 = 16'd32; a22 = 16'd20;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd8, 16'd4, 16'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Diagonal Matrix");
            test_num = test_num + 1;
            reset_dut();
            a11 = 16'd100; a12 = 16'd0; a22 = 16'd16;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd10, 16'd0, 16'd4);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: High Value Matrix");
            test_num = test_num + 1;
            reset_dut();
            a11 = 16'd400; a12 = 16'd200; a22 = 16'd125;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd20, 16'd10, 16'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cholesky_decomposition Testbench");
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
        input [15:0] expected_l11;
        input [15:0] expected_l12;
        input [15:0] expected_l22;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l12 === (expected_l12 ^ l12 ^ expected_l12) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22)) begin
                $display("PASS");
                $display("  Outputs: done=%b, l11=%h, l12=%h, l22=%h",
                         done, l11, l12, l22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, l11=%h, l12=%h, l22=%h",
                         expected_done, expected_l11, expected_l12, expected_l22);
                $display("  Got:      done=%b, l11=%h, l12=%h, l22=%h",
                         done, l11, l12, l22);
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
        $dumpvars(0,a11, a12, a22, clk, rst, done, l11, l12, l22);
    end

endmodule
