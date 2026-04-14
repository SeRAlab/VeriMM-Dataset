`timescale 1ns/1ps

module ecc_point_addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] p;
    reg rst;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] y1;
    reg [31:0] y2;
    wire done;
    wire [31:0] x3;
    wire [31:0] y3;

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
        .done(done),
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
            p = 0;
            x1 = 0; y1 = 0;
            x2 = 0; y2 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition (13,7) + (3,10) mod 23", test_num);
            reset_dut();
            p = 32'd23;
            x1 = 32'd13; y1 = 32'd7;
            x2 = 32'd3;  y2 = 32'd10;


            @(posedge clk);
            wait(done === 1'b1);
            #5;
            #1;

            check_outputs(1'b1, 32'd11, 32'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition (1,5) + (23,31) mod 97", test_num);
            reset_dut();
            p = 32'd97;
            x1 = 32'd1;  y1 = 32'd5;
            x2 = 32'd23; y2 = 32'd31;

            @(posedge clk);
            wait(done === 1'b1);
            #5;
            #1;

            check_outputs(1'b1, 32'd76, 32'd21);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition (2,26) + (70,4) mod 101", test_num);
            reset_dut();
            p = 32'd101;
            x1 = 32'd2;  y1 = 32'd26;
            x2 = 32'd70; y2 = 32'd4;

            @(posedge clk);
            wait(done === 1'b1);
            #5;
            #1;

            check_outputs(1'b1, 32'd7, 32'd38);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Addition (5,1) + (100,20) mod 127", test_num);
            reset_dut();
            p = 32'd127;
            x1 = 32'd5;   y1 = 32'd1;
            x2 = 32'd100; y2 = 32'd20;

            @(posedge clk);
            wait(done === 1'b1);
            #5;
            #1;

            check_outputs(1'b1, 32'd83, 32'd84);
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
        input [31:0] expected_x3;
        input [31:0] expected_y3;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: done=%b, x3=%h, y3=%h",
                         done, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, x3=%h, y3=%h",
                         expected_done, expected_x3, expected_y3);
                $display("  Got:      done=%b, x3=%h, y3=%h",
                         done, x3, y3);
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
        $dumpvars(0,clk, p, rst, x1, x2, y1, y2, done, x3, y3);
    end

endmodule
