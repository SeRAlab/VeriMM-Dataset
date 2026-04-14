`timescale 1ns/1ps

module chacha_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] x0;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] x3;
    wire [31:0] out0;
    wire [31:0] out1;
    wire [31:0] out2;
    wire [31:0] out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_quarter_round dut (
        .clk(clk),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x0 = 32'h0;
            x1 = 32'h0;
            x2 = 32'h0;
            x3 = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            x0 = 32'h0; x1 = 32'h0; x2 = 32'h0; x3 = 32'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: RFC Sample Vector 1", test_num);
            reset_dut();
            x0 = 32'h11111111; x1 = 32'h01020304; x2 = 32'h9b8d6f43; x3 = 32'h01234567;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: RFC Sample Vector 2", test_num);
            reset_dut();
            x0 = 32'h879531e0; x1 = 32'hc5ecf37d; x2 = 32'h516461b1; x3 = 32'hd916659c;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hddd5aa99, 32'h1bc34f1b, 32'ha66403e2, 32'h143e0d9d);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Fs", test_num);
            reset_dut();
            x0 = 32'hffffffff; x1 = 32'hffffffff; x2 = 32'hffffffff; x3 = 32'hffffffff;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'heffffffd, 32'h00700880, 32'hf000efee, 32'heffffdef);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();
            x0 = 32'h55555555; x1 = 32'haaaaaaaa; x2 = 32'h55555555; x3 = 32'haaaaaaaa;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hffffffff, 32'haaaaaa02, 32'h55555554, 32'haaaaaaaa);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One", test_num);
            reset_dut();
            x0 = 32'h00000001; x1 = 32'h00000000; x2 = 32'h00000000; x3 = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000001, 32'h00008080, 32'h00010001, 32'h01010000);
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
        input [31:0] expected_out0;
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        input [31:0] expected_out3;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
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
        $dumpvars(0,clk, x0, x1, x2, x3, out0, out1, out2, out3);
    end

endmodule
