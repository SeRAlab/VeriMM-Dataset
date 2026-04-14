`timescale 1ns/1ps

module and8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and8 dut (
        .a(a),
        .b(b),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 8'h00;
            b = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All zeros");
            reset_dut();
            test_num = test_num + 1;
            a = 8'h00;
            b = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones");
            reset_dut();
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Complementary patterns (AA & 55)");
            reset_dut();
            test_num = test_num + 1;
            a = 8'hAA;
            b = 8'h55;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise pattern overlap (F0 & CC)");
            reset_dut();
            test_num = test_num + 1;
            a = 8'hF0;
            b = 8'hCC;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Arbitrary values (12 & 34)");
            reset_dut();
            test_num = test_num + 1;
            a = 8'h12;
            b = 8'h34;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify input isolation (ignoring changes)");
            reset_dut();
            test_num = test_num + 1;
            a = 8'h0F;
            b = 8'h0F;
            @(posedge clk);
            #2 a = 8'hFF;
            #2 b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Walking ones bitwise test");
            reset_dut();
            test_num = test_num + 1;
            a = 8'h81;
            b = 8'h83;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Alternating bits");
            reset_dut();
            test_num = test_num + 1;
            a = 8'hCC;
            b = 8'h33;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and8 Testbench");
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, result);
    end

endmodule
