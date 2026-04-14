`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire valid;
    wire [15:0] x3;
    wire [15:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .clk(clk),
        .reset(reset),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .valid(valid),
        .x3(x3),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x1 = 0;
            x2 = 0;
            y1 = 0;
            y2 = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Point Addition (P + Q)");
            test_num = test_num + 1;
            reset_dut();
            x1 = 16'd5; y1 = 16'd1;
            x2 = 16'd6; y2 = 16'd3;


            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd10, 16'd6);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Point Doubling (P + P)");
            test_num = test_num + 1;
            reset_dut();
            x1 = 16'd5; y1 = 16'd1;
            x2 = 16'd5; y2 = 16'd1;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd6, 16'd3);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Addition with Point at Infinity (P + O)");
            test_num = test_num + 1;
            reset_dut();
            x1 = 16'd5; y1 = 16'd1;
            x2 = 16'd0; y2 = 16'd0;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd5, 16'd1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Addition with Point at Infinity (O + P)");
            test_num = test_num + 1;
            reset_dut();
            x1 = 16'd0; y1 = 16'd0;
            x2 = 16'd6; y2 = 16'd3;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd6, 16'd3);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Additive Inverse (P + (-P) = O)");
            test_num = test_num + 1;
            reset_dut();
            x1 = 16'd5;  y1 = 16'd1;
            x2 = 16'd5;  y2 = 16'd16;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd0, 16'd0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Identity Addition (O + O)");
            test_num = test_num + 1;
            reset_dut();
            x1 = 16'd0; y1 = 16'd0;
            x2 = 16'd0; y2 = 16'd0;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd0, 16'd0);
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
        input expected_valid;
        input [15:0] expected_x3;
        input [15:0] expected_y3;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, x3=%h, y3=%h",
                         valid, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, x3=%h, y3=%h",
                         expected_valid, expected_x3, expected_y3);
                $display("  Got:      valid=%b, x3=%h, y3=%h",
                         valid, x3, y3);
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
        $dumpvars(0,clk, reset, x1, x2, y1, y2, valid, x3, y3);
    end

endmodule
