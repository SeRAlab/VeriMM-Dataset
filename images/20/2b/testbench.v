`timescale 1ns/1ps

module chacha_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a_in;
    reg [31:0] b_in;
    reg [31:0] c_in;
    reg clk;
    reg [31:0] d_in;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] c_out;
    wire [31:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_quarter_round dut (
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .clk(clk),
        .d_in(d_in),
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
            a_in = 32'h0;
            b_in = 32'h0;
            c_in = 32'h0;
            d_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            reset_dut();

            a_in = 32'h00000000;
            b_in = 32'h00000000;
            c_in = 32'h00000000;
            d_in = 32'h00000000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (0x1) Input", test_num);
            reset_dut();

            a_in = 32'h00000001;
            b_in = 32'h00000001;
            c_in = 32'h00000001;
            d_in = 32'h00000001;

            @(posedge clk);
            #1;





            #1;






            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All F's Input", test_num);
            reset_dut();

            a_in = 32'hffffffff;
            b_in = 32'hffffffff;
            c_in = 32'hffffffff;
            d_in = 32'hffffffff;

            @(posedge clk);
            #1;





            #1;






            check_outputs(32'hefffffff, 32'h77808887, 32'hfefffeee, 32'hfeffffef);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Patterns", test_num);
            reset_dut();

            a_in = 32'h11111111;
            b_in = 32'h01020304;
            c_in = 32'h9b8d6f54;
            d_in = 32'h55aa55aa;

            @(posedge clk);
            #1;





            #1;






            check_outputs(32'hfd53b1d9, 32'h41c50690, 32'hcbc317c9, 32'hee0660bc);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Bit Influence", test_num);
            reset_dut();

            a_in = 32'hdeadbeef;
            b_in = 32'hfacefeed;
            c_in = 32'h12345678;
            d_in = 32'h87654321;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hae557955, 32'he06fe943, 32'h537960cd, 32'h4827ab57);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha_quarter_round Testbench");
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
        $dumpvars(0,a_in, b_in, c_in, clk, d_in, a_out, b_out, c_out, d_out);
    end

endmodule
