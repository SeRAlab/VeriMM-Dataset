`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    reg reset;
    reg start;
    wire done;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_quarter_round dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .reset(reset),
        .start(start),
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
            reset = 1;
            start = 0;
            a = 32'h0;
            b = 32'h0;
            c = 32'h0;
            d = 32'h0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Mixed Values 1", test_num);
            reset_dut();
            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hea2a92f4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sequence 0,1,2,3", test_num);
            reset_dut();
            a = 32'h00000000;
            b = 32'h00000001;
            c = 32'h00000002;
            d = 32'h00000003;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h20003001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: All Ones (FFFFFFFF)", test_num);
            reset_dut();
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            c = 32'hFFFFFFFF;
            d = 32'hFFFFFFFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hefffffff);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Small integers 1,2,3,4", test_num);
            reset_dut();
            a = 32'h00000001;
            b = 32'h00000002;
            c = 32'h00000003;
            d = 32'h00000004;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h70001003);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_quarter_round Testbench");
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
        input [31:0] expected_result;
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
        $dumpvars(0,a, b, c, clk, d, reset, start, done, result);
    end

endmodule
