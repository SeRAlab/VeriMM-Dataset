`timescale 1ns/1ps

module xor8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire [7:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor8 dut (
        .A(A),
        .B(B),
        .clk(clk),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A <= 8'h00;
            B <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: All Zeros (0x00 ^ 0x00)", test_num);
            A <= 8'h00;
            B <= 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: All Ones (0xFF ^ 0xFF)", test_num);
            A <= 8'hFF;
            B <= 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Alternating Bits (0xAA ^ 0x55)", test_num);
            A <= 8'hAA;
            B <= 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Zero Identity (0xA5 ^ 0x00)", test_num);
            A <= 8'hA5;
            B <= 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Nibble Swap (0xF0 ^ 0x0F)", test_num);
            A <= 8'hF0;
            B <= 8'h0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Arbitrary Pattern (0x12 ^ 0x34)", test_num);
            A <= 8'h12;
            B <= 8'h34;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h12 ^ 8'h34);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: Walking Bit (0x80 ^ 0x01)", test_num);
            A <= 8'h80;
            B <= 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: Complement check (0xCC ^ 0x33)", test_num);
            A <= 8'hCC;
            B <= 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor8 Testbench");
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
        input [7:0] expected_X;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
        $dumpvars(0,A, B, clk, X);
    end

endmodule
