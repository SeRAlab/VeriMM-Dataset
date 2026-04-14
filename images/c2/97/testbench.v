`timescale 1ns/1ps

module rising_edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rising_edge_detector dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset = 1;
        in = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Post-Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single bit rising edge", test_num);
        reset_dut();
        in = 32'h0000_0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Output persistence (sticky bit)", test_num);
        reset_dut();
        in = 32'h0000_0002;
        @(posedge clk);
        in = 32'h0000_0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Falling edge detection", test_num);
        reset_dut();

        reset = 1;
        in = 32'h0000_0004;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        in = 32'h0000_0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Multiple bits simultaneous trigger", test_num);
        reset_dut();
        in = 32'hA5A5_A5A5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5_A5A5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Sequential accumulation", test_num);
        reset_dut();
        in = 32'h0000_0001;
        @(posedge clk);
        in = 32'h0000_0003;
        @(posedge clk);
        in = 32'h0000_0007;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0007);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: All bits rising edge", test_num);
        reset_dut();
        in = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Reset clearing accumulated bits", test_num);
        reset_dut();
        in = 32'hF0F0_F0F0;
        @(posedge clk);

        reset = 1;
        @(posedge clk);
        reset = 0;
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rising_edge_detector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
