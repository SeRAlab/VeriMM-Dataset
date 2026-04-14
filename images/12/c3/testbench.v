`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    reg reset;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] c_out;
    wire [31:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .reset(reset),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 32'h0;
            b = 32'h0;
            c = 32'h0;
            d = 32'h0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase%03d: All Zeros", test_num);

            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase%03d: RFC Standard Vector", test_num);

            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;

            @(posedge clk);
            @(posedge clk);
            #1;





            #1;






            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase%03d: Alternating Bits", test_num);

            a = 32'haaaaaaaa;
            b = 32'h55555555;
            c = 32'haaaaaaaa;
            d = 32'h55555555;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000fff, 32'hfdd57f7f, 32'hfffaaafe, 32'haaa555aa);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase%03d: Complex Mix", test_num);

            a = 32'h87654321;
            b = 32'h12345678;
            c = 32'hfedcba98;
            d = 32'h89abcdef;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0364c60f, 32'hf11274c0, 32'he829089f, 32'h12d63dd5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase%03d: Low Value Propagation", test_num);

            a = 32'h00000001;
            b = 32'h00000001;
            c = 32'h00000001;
            d = 32'h00000001;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
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
        input [31:0] expected_a_out;
        input [31:0] expected_b_out;
        input [31:0] expected_c_out;
        input [31:0] expected_d_out;
        begin
            if (expected_a_out === (expected_a_out ^ a_out ^ expected_a_out) &&
                expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: a_out=%h, b_out=%h, c_out=%h, d_out=%h",
                         a_out, b_out, c_out, d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_out=%h, b_out=%h, c_out=%h, d_out=%h",
                         expected_a_out, expected_b_out, expected_c_out, expected_d_out);
                $display("  Got:      a_out=%h, b_out=%h, c_out=%h, d_out=%h",
                         a_out, b_out, c_out, d_out);
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
        $dumpvars(0,a, b, c, clk, d, reset, a_out, b_out, c_out, d_out);
    end

endmodule
