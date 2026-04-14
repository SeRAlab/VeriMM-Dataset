`timescale 1ns/1ps

module divider_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg rst_n;
    reg start;
    wire done;
    wire [7:0] qout;
    wire [7:0] rout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_8bit dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .qout(qout),
        .rout(rout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            start = 1'b0;
            dividend = 8'h0;
            divisor = 8'h0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1'b1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Simple division (20 / 4)", test_num);
            dividend = 8'd20;
            divisor = 8'd4;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd5, 8'd0);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Division with remainder (25 / 7)", test_num);
            dividend = 8'd25;
            divisor = 8'd7;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd3, 8'd4);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Dividend < Divisor (5 / 10)", test_num);
            dividend = 8'd5;
            divisor = 8'd10;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0, 8'd5);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Divide by one (100 / 1)", test_num);
            dividend = 8'd100;
            divisor = 8'd1;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd100, 8'd0);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Dividend is zero (0 / 15)", test_num);
            dividend = 8'd0;
            divisor = 8'd15;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0, 8'd0);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Max values (255 / 2)", test_num);
            dividend = 8'd255;
            divisor = 8'd2;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd127, 8'd1);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Equal values (123 / 123)", test_num);
            dividend = 8'd123;
            divisor = 8'd123;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd1, 8'd0);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Prime division (17 / 3)", test_num);
            dividend = 8'd17;
            divisor = 8'd3;
            @(posedge clk);
            #1 start = 1'b1;

            wait(done == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd5, 8'd2);

            #1 start = 1'b0;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_8bit Testbench");
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
        input expected_done;
        input [7:0] expected_qout;
        input [7:0] expected_rout;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_qout === (expected_qout ^ qout ^ expected_qout) &&
                expected_rout === (expected_rout ^ rout ^ expected_rout)) begin
                $display("PASS");
                $display("  Outputs: done=%b, qout=%h, rout=%h",
                         done, qout, rout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, qout=%h, rout=%h",
                         expected_done, expected_qout, expected_rout);
                $display("  Got:      done=%b, qout=%h, rout=%h",
                         done, qout, rout);
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
        $dumpvars(0,clk, dividend, divisor, rst_n, start, done, qout, rout);
    end

endmodule
