`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din0;
    reg [31:0] din1;
    reg [31:0] din2;
    reg [31:0] din3;
    reg rst;
    reg valid_in;
    wire [31:0] dout0;
    wire [31:0] dout1;
    wire [31:0] dout2;
    wire [31:0] dout3;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .clk(clk),
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .rst(rst),
        .valid_in(valid_in),
        .dout0(dout0),
        .dout1(dout1),
        .dout2(dout2),
        .dout3(dout3),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            din0 = 0;
            din1 = 0;
            din2 = 0;
            din3 = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: DC Input [1,1,1,1]", test_num);

            valid_in = 1;
            din0 = 32'h0001_0000;
            din1 = 32'h0001_0000;
            din2 = 32'h0001_0000;
            din3 = 32'h0001_0000;

            @(posedge clk);
            valid_in = 0;


            @(posedge clk);
            #1;

            check_outputs(32'h0004_0000, 32'h0000_0000, 32'h0000_0000, 32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Impulse [1,0,0,0]", test_num);

            valid_in = 1;
            din0 = 32'h0001_0000;
            din1 = 32'h0000_0000;
            din2 = 32'h0000_0000;
            din3 = 32'h0000_0000;

            @(posedge clk);
            valid_in = 0;

            @(posedge clk);
            #1;

            check_outputs(32'h0001_0000, 32'h0001_0000, 32'h0001_0000, 32'h0001_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Shifted Impulse [0,1,0,0]", test_num);

            valid_in = 1;
            din0 = 32'h0000_0000;
            din1 = 32'h0001_0000;
            din2 = 32'h0000_0000;
            din3 = 32'h0000_0000;

            @(posedge clk);
            valid_in = 0;

            @(posedge clk);

            #1;


            check_outputs(32'h0001_0000, 32'h0000_FFFF, 32'hFFFF_0000, 32'h0000_0001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: High Freq Real [2,-2,2,-2]", test_num);

            valid_in = 1;
            din0 = 32'h0002_0000;
            din1 = 32'hFFFE_0000;
            din2 = 32'h0002_0000;
            din3 = 32'hFFFE_0000;

            @(posedge clk);
            valid_in = 0;

            @(posedge clk);
            #1;

            check_outputs(32'h0000_0000, 32'h0000_0000, 32'h0008_0000, 32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Complex Rotation [1, j, -1, -j]", test_num);

            valid_in = 1;
            din0 = 32'h0001_0000;
            din1 = 32'h0000_0001;
            din2 = 32'hFFFF_0000;
            din3 = 32'h0000_FFFF;

            @(posedge clk);
            valid_in = 0;

            @(posedge clk);
            #1;

            check_outputs(32'h0000_0000, 32'h0004_0000, 32'h0000_0000, 32'h0000_0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        input [31:0] expected_dout0;
        input [31:0] expected_dout1;
        input [31:0] expected_dout2;
        input [31:0] expected_dout3;
        input expected_valid_out;
        begin
            if (expected_dout0 === (expected_dout0 ^ dout0 ^ expected_dout0) &&
                expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2) &&
                expected_dout3 === (expected_dout3 ^ dout3 ^ expected_dout3) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: dout0=%h, dout1=%h, dout2=%h, dout3=%h, valid_out=%b",
                         dout0, dout1, dout2, dout3, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout0=%h, dout1=%h, dout2=%h, dout3=%h, valid_out=%b",
                         expected_dout0, expected_dout1, expected_dout2, expected_dout3, expected_valid_out);
                $display("  Got:      dout0=%h, dout1=%h, dout2=%h, dout3=%h, valid_out=%b",
                         dout0, dout1, dout2, dout3, valid_out);
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
        $dumpvars(0,clk, din0, din1, din2, din3, rst, valid_in, dout0, dout1, dout2, dout3, valid_out);
    end

endmodule
