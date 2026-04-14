`timescale 1ns/1ps

module convolutional_encoder_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg clk;
    reg rst;
    wire Y1;
    wire Y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolutional_encoder dut (
        .D(D),
        .clk(clk),
        .rst(rst),
        .Y1(Y1),
        .Y2(Y2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            D = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1", test_num);
            reset_dut();
            @(negedge clk) D = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 1, 1", test_num);
            reset_dut();
            @(negedge clk) D = 1;
            @(negedge clk) D = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 1, 1, 1", test_num);
            reset_dut();
            @(negedge clk) D = 1;
            @(negedge clk) D = 1;
            @(negedge clk) D = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 1, 0, 0", test_num);
            reset_dut();
            @(negedge clk) D = 1;
            @(negedge clk) D = 0;
            @(negedge clk) D = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 0, 1, 0", test_num);
            reset_dut();
            @(negedge clk) D = 0;
            @(negedge clk) D = 1;
            @(negedge clk) D = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 1, 0, 1", test_num);
            reset_dut();
            @(negedge clk) D = 1;
            @(negedge clk) D = 0;
            @(negedge clk) D = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 0, 0, 1", test_num);
            reset_dut();
            @(negedge clk) D = 0;
            @(negedge clk) D = 0;
            @(negedge clk) D = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input sequence 1, 1, 0", test_num);
            reset_dut();
            @(negedge clk) D = 1;
            @(negedge clk) D = 1;
            @(negedge clk) D = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
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
        input expected_Y1;
        input expected_Y2;
        begin
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y2=%b",
                         Y1, Y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y2=%b",
                         expected_Y1, expected_Y2);
                $display("  Got:      Y1=%b, Y2=%b",
                         Y1, Y2);
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
        $dumpvars(0,D, clk, rst, Y1, Y2);
    end

endmodule
