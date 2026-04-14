`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
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
            x1 = 0; x2 = 0; y1 = 0; y2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x1 = 8'd6;  y1 = 8'd6;
            x2 = 8'd10; y2 = 8'd5;
            $display("Test %0d: Adding distinct points (6,6) and (10,5)...", test_num);
            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0, 8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x1 = 8'd6; y1 = 8'd6;
            x2 = 8'd6; y2 = 8'd6;
            $display("Test %0d: Doubling point (6,6)...", test_num);
            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd9, 8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x1 = 8'd6; y1 = 8'd6;
            x2 = 8'd6; y2 = 8'd11;
            $display("Test %0d: Adding point and its inverse (6,6) and (6,11)...", test_num);
            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x1 = 8'd0;  y1 = 8'd0;
            x2 = 8'd10; y2 = 8'd12;
            $display("Test %0d: Adding Infinity and (10,12)...", test_num);
            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd10, 8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x1 = 8'd0;  y1 = 8'd1;
            x2 = 8'd15; y2 = 8'd12;
            $display("Test %0d: Adding (0,1) and (15,12) to get (11,0)...", test_num);
            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd11, 8'd0);
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
        $dumpvars(0,clk, rst, x1, x2, y1, y2, valid, x3, y3);
    end

endmodule
