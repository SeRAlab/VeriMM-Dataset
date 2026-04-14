`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg rst;
    reg start;
    wire done;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .clk(clk),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .rst(rst),
        .start(start),
        .done(done),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            multiplicand = 0;
            multiplier = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = 8'd12;
            multiplier = 8'd10;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd120);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = 8'd15;
            multiplier = -8'd5;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, -16'd75);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = -8'd10;
            multiplier = 8'd8;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, -16'd80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = -8'd6;
            multiplier = -8'd7;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd42);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = 8'd0;
            multiplier = -8'd128;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = 8'd127;
            multiplier = 8'd127;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd16129);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = -8'd128;
            multiplier = 8'd127;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, -16'd16256);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = -8'd128;
            multiplier = -8'd128;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd16384);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            multiplicand = 8'd45;
            multiplier = -8'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, -16'd45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_product;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: done=%b, product=%h",
                         done, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, product=%h",
                         expected_done, expected_product);
                $display("  Got:      done=%b, product=%h",
                         done, product);
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
        $dumpvars(0,clk, multiplicand, multiplier, rst, start, done, product);
    end

endmodule
