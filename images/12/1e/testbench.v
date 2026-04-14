`timescale 1ns/1ps

module rsa_exponentiation_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg clk;
    reg [7:0] e;
    reg [7:0] n;
    reg rst;
    wire done;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_exponentiation dut (
        .a(a),
        .clk(clk),
        .e(e),
        .n(n),
        .rst(rst),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 2^3 mod 10", test_num);
        a = 8'd2; e = 8'd3; n = 8'd10;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 3^4 mod 11", test_num);
        a = 8'd3; e = 8'd4; n = 8'd11;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 5^0 mod 13", test_num);
        a = 8'd5; e = 8'd0; n = 8'd13;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0^5 mod 7", test_num);
        a = 8'd0; e = 8'd5; n = 8'd7;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 7^1 mod 15", test_num);
        a = 8'd7; e = 8'd1; n = 8'd15;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 10^2 mod 13", test_num);
        a = 8'd10; e = 8'd2; n = 8'd13;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd9);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 2^8 mod 17", test_num);
        a = 8'd2; e = 8'd8; n = 8'd17;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 15^2 mod 200", test_num);
        a = 8'd15; e = 8'd2; n = 8'd200;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd25);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 1^100 mod 50", test_num);
        a = 8'd1; e = 8'd100; n = 8'd50;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 2^7 mod 100", test_num);
        a = 8'd2; e = 8'd7; n = 8'd100;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd28);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_exponentiation Testbench");
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
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,a, clk, e, n, rst, done, result);
    end

endmodule
