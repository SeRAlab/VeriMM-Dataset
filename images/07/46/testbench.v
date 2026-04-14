`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_a;
    reg [31:0] in_b;
    reg [31:0] in_c;
    reg [31:0] in_d;
    reg rst;
    wire [31:0] out_a;
    wire [31:0] out_b;
    wire [31:0] out_c;
    wire [31:0] out_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_quarter_round dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
        .in_c(in_c),
        .in_d(in_d),
        .rst(rst),
        .out_a(out_a),
        .out_b(out_b),
        .out_c(out_c),
        .out_d(out_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_a = 32'h0;
            in_b = 32'h0;
            in_c = 32'h0;
            in_d = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros Check", test_num);
            reset_dut();
            in_a = 32'h0; in_b = 32'h0; in_c = 32'h0; in_d = 32'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: RFC 7539 Reference Vector", test_num);
            reset_dut();
            in_a = 32'h61707865;
            in_b = 32'h82202020;
            in_c = 32'h517d1002;
            in_d = 32'h7a353643;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h1c2910a7, 32'h8a5ebddb, 32'haf8cc559, 32'haf8902b2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All Bits Set", test_num);
            reset_dut();
            in_a = 32'hffffffff;
            in_b = 32'hffffffff;
            in_c = 32'hffffffff;
            in_d = 32'hffffffff;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hefffffff, 32'h80008887, 32'hff00feee, 32'hfeffffef);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Mixed Pattern", test_num);
            reset_dut();
            in_a = 32'h11111111;
            in_b = 32'h01020304;
            in_c = 32'h9b8d6f43;
            in_d = 32'h01234567;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'haa2a92f4, 32'hcb1cd8ee, 32'h4581476e, 32'h5881c4fb);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Reset Verification", test_num);
            reset_dut();
            in_a = 32'h12345678; in_b = 32'h87654321;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
            rst = 0;
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
        input [31:0] expected_out_a;
        input [31:0] expected_out_b;
        input [31:0] expected_out_c;
        input [31:0] expected_out_d;
        begin
            if (expected_out_a === (expected_out_a ^ out_a ^ expected_out_a) &&
                expected_out_b === (expected_out_b ^ out_b ^ expected_out_b) &&
                expected_out_c === (expected_out_c ^ out_c ^ expected_out_c) &&
                expected_out_d === (expected_out_d ^ out_d ^ expected_out_d)) begin
                $display("PASS");
                $display("  Outputs: out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         out_a, out_b, out_c, out_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         expected_out_a, expected_out_b, expected_out_c, expected_out_d);
                $display("  Got:      out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         out_a, out_b, out_c, out_d);
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
        $dumpvars(0,clk, in_a, in_b, in_c, in_d, rst, out_a, out_b, out_c, out_d);
    end

endmodule
