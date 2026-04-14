`timescale 1ns/1ps

module multi_booth_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire [15:0] p;
    wire rdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multi_booth_8bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .p(p),
        .rdy(rdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive * Positive (10 * 12)", test_num);
            a = 8'd10;
            b = 8'd12;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(16'd120, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive * Negative (5 * -4)", test_num);
            a = 8'd5;
            b = -8'd4;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(-16'd20, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative * Positive (-10 * 3)", test_num);
            a = -8'd10;
            b = 8'd3;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(-16'd30, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative * Negative (-6 * -7)", test_num);
            a = -8'd6;
            b = -8'd7;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(16'd42, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by Zero (0 * -50)", test_num);
            a = 8'd0;
            b = -8'd50;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Positive Values (127 * 2)", test_num);
            a = 8'h7F;
            b = 8'd2;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(16'd254, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value (-128 * 1)", test_num);
            a = 8'h80;
            b = 8'd1;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(16'hFF80, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative One (-1 * -1)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            reset_dut();
            wait(rdy);
            @(posedge clk);
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multi_booth_8bit Testbench");
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
        input [15:0] expected_p;
        input expected_rdy;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_rdy === (expected_rdy ^ rdy ^ expected_rdy)) begin
                $display("PASS");
                $display("  Outputs: p=%h, rdy=%b",
                         p, rdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h, rdy=%b",
                         expected_p, expected_rdy);
                $display("  Got:      p=%h, rdy=%b",
                         p, rdy);
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
        $dumpvars(0,a, b, clk, reset, p, rdy);
    end

endmodule
