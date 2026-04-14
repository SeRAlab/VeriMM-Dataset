`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] symbol;
    wire [3:0] I;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
        .rst(rst),
        .symbol(symbol),
        .I(I),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        symbol = 4'b0000;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        symbol = 4'b0000;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        symbol = 4'b0001;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0, 4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        symbol = 4'b0010;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h1, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        symbol = 4'b0011;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h1, 4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        symbol = 4'b0100;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0, 4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        symbol = 4'b0101;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0, 4'hE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        symbol = 4'b0110;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h2, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        symbol = 4'b0111;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h2, 4'h1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        symbol = 4'b1000;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0, 4'hD);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        symbol = 4'b1010;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h3, 4'h0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        reset_dut();
        symbol = 4'b1100;
        @(posedge clk);

        #1 #1;
 check_outputs(4'hF, 4'h0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        reset_dut();
        symbol = 4'b0011;
        @(posedge clk);
        symbol = 4'b0000;
        @(posedge clk);
        #1 #1;
 check_outputs(4'h0, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_I;
        input [3:0] expected_Q;
        begin
            if (expected_I === (expected_I ^ I ^ expected_I) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: I=%h, Q=%h",
                         I, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h, Q=%h",
                         expected_I, expected_Q);
                $display("  Got:      I=%h, Q=%h",
                         I, Q);
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
        $dumpvars(0,clk, rst, symbol, I, Q);
    end

endmodule
