`timescale 1ns/1ps

module convolutional_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    wire dout0;
    wire dout1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolutional_encoder dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout0(dout0),
        .dout1(dout1)
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
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 0-1-0", test_num);
            reset_dut();
            din = 0;
            @(posedge clk);
            din = 1;
            @(posedge clk);
            din = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1-1-1", test_num);
            reset_dut();
            din = 1;
            @(posedge clk);
            din = 1;
            @(posedge clk);
            din = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1-0-1", test_num);
            reset_dut();
            din = 1;
            @(posedge clk);
            din = 0;
            @(posedge clk);
            din = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1-1-0", test_num);
            reset_dut();
            din = 1;
            @(posedge clk);
            din = 1;
            @(posedge clk);
            din = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and zero input", test_num);
            reset_dut();
            din = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 1-0-0", test_num);
            reset_dut();
            din = 1;
            @(posedge clk);
            din = 0;
            @(posedge clk);
            din = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("convolutional_encoder Testbench");
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
        input expected_dout0;
        input expected_dout1;
        begin
            if (expected_dout0 === (expected_dout0 ^ dout0 ^ expected_dout0) &&
                expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1)) begin
                $display("PASS");
                $display("  Outputs: dout0=%b, dout1=%b",
                         dout0, dout1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout0=%b, dout1=%b",
                         expected_dout0, expected_dout1);
                $display("  Got:      dout0=%b, dout1=%b",
                         dout0, dout1);
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
        $dumpvars(0,clk, din, rst, dout0, dout1);
    end

endmodule
