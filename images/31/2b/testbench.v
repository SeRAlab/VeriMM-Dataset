`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] din;
    reg rst;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        din = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        repeat(8) begin
            din = 4'h0;
            @(posedge clk);
        end
        #1 #1;
 check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        repeat(8) begin
            din = 4'hF;
            @(posedge clk);
        end
        #1 #1;
 check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    integer i;
    begin
        reset_dut();
        test_num = 3;
        for (i = 1; i <= 8; i = i + 1) begin
            din = i[3:0];
            @(posedge clk);
        end
        #1 #1;
 check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    integer i;
    begin
        reset_dut();
        test_num = 4;
        for (i = 0; i < 4; i = i + 1) begin
            din = 4'hA; @(posedge clk);
            din = 4'h5; @(posedge clk);
        end
        #1 #1;
 check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        din = 4'h1; @(posedge clk);
        din = 4'h2; @(posedge clk);
        din = 4'h4; @(posedge clk);
        din = 4'h8; @(posedge clk);
        din = 4'h1; @(posedge clk);
        din = 4'h2; @(posedge clk);
        din = 4'h4; @(posedge clk);
        din = 4'h8; @(posedge clk);
        #1 #1;
 check_outputs(32'h12481248);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, rst, dout);
    end

endmodule
