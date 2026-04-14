`timescale 1ns/1ps

module Reed_Solomon_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] message;
    reg rst;
    wire [15:0] codeword;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Reed_Solomon_Encoder dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .codeword(codeword),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message = 8'h00;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Zero Input", test_num);
            reset_dut();
            message = 8'h00;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Unit Input (0x01)", test_num);
            reset_dut();
            message = 8'h01;

            wait(done);
            @(posedge clk);



            if (done == 1'b1 && codeword[15:8] == 8'h01) begin
                $display("  PASS: Data transmitted correctly in codeword.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Codeword mismatch.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: All-Ones Input (0xFF)", test_num);
            reset_dut();
            message = 8'hFF;

            wait(done);
            @(posedge clk);
            if (done == 1'b1 && codeword[15:8] == 8'hFF) begin
                $display("  PASS: MSB contains message 0xFF.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Unexpected codeword/done state.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Bits (0xAA)", test_num);
            reset_dut();
            message = 8'hAA;

            wait(done);
            @(posedge clk);
            if (done == 1'b1 && codeword[15:8] == 8'hAA) begin
                $display("  PASS: Handshake and message integrity verified.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Handshake or message error.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Mid-operation Reset", test_num);
            reset_dut();
            message = 8'h55;
            repeat(2) @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            if (done === 1'b0) begin
                $display("  PASS: Reset successfully cleared 'done' signal.");
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: 'done' signal remained high after reset.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Reed_Solomon_Encoder Testbench");
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
        input [15:0] expected_codeword;
        input expected_done;
        begin
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h, done=%b",
                         codeword, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h, done=%b",
                         expected_codeword, expected_done);
                $display("  Got:      codeword=%h, done=%b",
                         codeword, done);
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
        $dumpvars(0,clk, message, rst, codeword, done);
    end

endmodule
