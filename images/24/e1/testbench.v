`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] x;
    wire [7:0] cA;
    wire [7:0] cD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .clk(clk),
        .x(x),
        .cA(cA),
        .cD(cD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x <= 8'd0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: DC Signal (100, 100)");
            reset_dut();
            x <= 8'd100; @(posedge clk);
            x <= 8'd100; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd100, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Rising Edge (20, 40)");
            reset_dut();
            x <= 8'd20; @(posedge clk);
            x <= 8'd40; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd30, 8'hF6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Falling Edge (40, 20)");
            reset_dut();
            x <= 8'd40; @(posedge clk);
            x <= 8'd20; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd30, 8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Zeros");
            reset_dut();
            x <= 8'd0; @(posedge clk);
            x <= 8'd0; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Max Values (255, 255)");
            reset_dut();
            x <= 8'd255; @(posedge clk);
            x <= 8'd255; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Large Step (200, 100)");
            reset_dut();
            x <= 8'd200; @(posedge clk);
            x <= 8'd100; @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd150, 8'h32);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Impulse (254, 0)");
            reset_dut();
            x <= 8'd254; @(posedge clk);
            x <= 8'd0;   @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'd127, 8'h7F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_cA;
        input [7:0] expected_cD;
        begin
            if (expected_cA === (expected_cA ^ cA ^ expected_cA) &&
                expected_cD === (expected_cD ^ cD ^ expected_cD)) begin
                $display("PASS");
                $display("  Outputs: cA=%h, cD=%h",
                         cA, cD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cA=%h, cD=%h",
                         expected_cA, expected_cD);
                $display("  Got:      cA=%h, cD=%h",
                         cA, cD);
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
        $dumpvars(0,clk, x, cA, cD);
    end

endmodule
