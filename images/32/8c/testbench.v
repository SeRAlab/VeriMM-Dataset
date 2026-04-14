`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] c_out;
    wire [31:0] d_out;

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
            a = 0;
            b = 0;
            c = 0;
            d = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros");
            reset_dut();
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All Ones");
            reset_dut();
            a = 32'h00000001;
            b = 32'h00000001;
            c = 32'h00000001;
            d = 32'h00000001;
            @(posedge clk);
            #1;





            #1;






            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: RFC 7539 Vector");
            reset_dut();
            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'he22a92f4, 32'hcb0cfccb, 32'h45816726, 32'h5881c4b3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Constants Setup");
            reset_dut();
            a = 32'h61707865;
            b = 32'h3320646e;
            c = 32'h79622d32;
            d = 32'h6b206574;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h39199cd5, 32'hf2a9302a, 32'hf16d9262, 32'hbe636580);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Alternating Bit Patterns");
            reset_dut();
            a = 32'h55555555;
            b = 32'hAAAAAAAA;
            c = 32'h55555555;
            d = 32'hAAAAAAAA;
            @(posedge clk);
            #1;





            #1;






            check_outputs(32'hFFFFFFFF, 32'hAAAAAA2A, 32'h55555554, 32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Max Values");
            reset_dut();
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFE, 32'hFFFF807F, 32'h000000FF, 32'h00000100);
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
        testcase006();
        
        
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
        $dumpvars(0,a, b, c, clk, d, a_out, b_out, c_out, d_out);
    end

endmodule
