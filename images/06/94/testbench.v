`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg rst_n;
    wire done;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst_n(rst_n),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            A = 0;
            B = 0;
            #20;
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest %0d: 8 / 2", test_num);
            A = 4'd8;
            B = 4'd2;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd4, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest %0d: 7 / 3", test_num);
            A = 4'd7;
            B = 4'd3;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd2, 4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest %0d: 2 / 5", test_num);
            A = 4'd2;
            B = 4'd5;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest %0d: 5 / 1", test_num);
            A = 4'd5;
            B = 4'd1;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd5, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTest %0d: 0 / 5", test_num);
            A = 4'd0;
            B = 4'd5;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTest %0d: 15 / 15", test_num);
            A = 4'd15;
            B = 4'd15;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTest %0d: 15 / 2", test_num);
            A = 4'd15;
            B = 4'd2;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd7, 4'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("\nTest %0d: 10 / 6", test_num);
            A = 4'd10;
            B = 4'd6;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 4'd4);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("\nTest %0d: 13 / 4", test_num);
            A = 4'd13;
            B = 4'd4;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd3, 4'd1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("\nTest %0d: 9 / 3", test_num);
            A = 4'd9;
            B = 4'd3;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd3, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_4bit Testbench");
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
        testcase010();
        
        
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
        $dumpvars(0,A, B, clk, rst_n, done, quotient, remainder);
    end

endmodule
