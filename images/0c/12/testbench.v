`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] din;
    reg reset;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0x0000)", test_num);
            reset_dut();
            repeat(8) begin
                din = 2'b00;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (0xFFFF)", test_num);
            reset_dut();
            repeat(8) begin
                din = 2'b11;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 10 (0xAAAA)", test_num);
            reset_dut();
            repeat(8) begin
                din = 2'b10;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating 01 (0x5555)", test_num);
            reset_dut();
            repeat(8) begin
                din = 2'b01;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            pattern = 16'h1234;
            $display("Test Case %0d: Pattern 0x1234", test_num);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                din = pattern[(i*2)+1 -: 2];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        reg [15:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            pattern = 16'hCAFE;
            $display("Test Case %0d: Pattern 0xCAFE", test_num);
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                din = pattern[(i*2)+1 -: 2];
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hCAFE);
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
        input [15:0] expected_dout;
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
        $dumpvars(0,clk, din, reset, dout);
    end

endmodule
