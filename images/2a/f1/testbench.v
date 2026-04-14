`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] p;
    reg rst;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire valid;
    wire [7:0] x3;
    wire [7:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_addition dut (
        .clk(clk),
        .p(p),
        .rst(rst),
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
            rst = 1;
            x1 = 0; y1 = 0; x2 = 0; y2 = 0; p = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task wait_for_valid;

        begin
            while (!valid) @(posedge clk);
            @(negedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Addition (5,1) + (6,3) mod 17", test_num);
            reset_dut();
            p = 8'd17;
            x1 = 8'd5;  y1 = 8'd1;
            x2 = 8'd6;  y2 = 8'd3;
            wait_for_valid();
            #1;

            check_outputs(1'b1, 8'd10, 8'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Addition (5,1) + (10,6) mod 17", test_num);
            reset_dut();
            p = 8'd17;
            x1 = 8'd5;  y1 = 8'd1;
            x2 = 8'd10; y2 = 8'd6;
            wait_for_valid();
            #1;

            check_outputs(1'b1, 8'd3, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (10,6) + (3,1) mod 17 -> (0,6)", test_num);
            reset_dut();
            p = 8'd17;
            x1 = 8'd10; y1 = 8'd6;
            x2 = 8'd3;  y2 = 8'd1;
            wait_for_valid();
            #1;

            check_outputs(1'b1, 8'd0, 8'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Addition mod 13", test_num);
            reset_dut();
            p = 8'd13;
            x1 = 8'd1;  y1 = 8'd5;
            x2 = 8'd2;  y2 = 8'd3;
            wait_for_valid();
            #1;

            check_outputs(1'b1, 8'd1, 8'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Commutative Property Check", test_num);
            reset_dut();
            p = 8'd17;
            x1 = 8'd6;  y1 = 8'd3;
            x2 = 8'd5;  y2 = 8'd1;
            wait_for_valid();
            #1;

            check_outputs(1'b1, 8'd10, 8'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_addition Testbench");
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
        input expected_valid;
        input [7:0] expected_x3;
        input [7:0] expected_y3;
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
        $dumpvars(0,clk, p, rst, x1, x2, y1, y2, valid, x3, y3);
    end

endmodule
