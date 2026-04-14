`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] symbol;
    wire [1:0] I;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .clk(clk),
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
            @(posedge clk);
            symbol <= 4'b0000;
            @(posedge clk);
            $display("DUT Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            symbol <= 4'b0000;
            @(posedge clk);
            #1;
            $display("Test Case 001: Symbol 0000");
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            symbol <= 4'b0011;
            @(posedge clk);
            #1;
            $display("Test Case 002: Symbol 0011");
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            symbol <= 4'b0110;
            @(posedge clk);
            #1;
            $display("Test Case 003: Symbol 0110");
            #1;

            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            symbol <= 4'b1001;
            @(posedge clk);
            #1;
            $display("Test Case 004: Symbol 1001");
            #1;

            check_outputs(2'b00, 2'b11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            symbol <= 4'b1111;
            @(posedge clk);
            #1;
            $display("Test Case 005: Symbol 1111");
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            symbol <= 4'b1010;
            @(posedge clk);
            #1;
            $display("Test Case 006: Symbol 1010");
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            symbol <= 4'b0101;
            @(posedge clk);
            #1;
            $display("Test Case 007: Symbol 0101");
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            symbol <= 4'b1100;
            @(posedge clk);
            #1;
            $display("Test Case 008: Symbol 1100");
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            symbol <= 4'b1000;
            @(posedge clk);
            #1;
            $display("Test Case 009: Symbol 1000");
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            symbol <= 4'b0111;
            @(posedge clk);
            #1;
            $display("Test Case 010: Symbol 0111");
            #1;

            check_outputs(2'b11, 2'b01);
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
        input [1:0] expected_I;
        input [1:0] expected_Q;
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
        $dumpvars(0,clk, symbol, I, Q);
    end

endmodule
