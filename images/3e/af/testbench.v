`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] received;
    reg rst;
    wire [2:0] decoded;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received(received),
        .rst(rst),
        .decoded(decoded),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            received = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            received = 2'b00; @(posedge clk);
            received = 2'b00; @(posedge clk);
            received = 2'b00; @(posedge clk);
            #1;

            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            received = 2'b11; @(posedge clk);
            received = 2'b01; @(posedge clk);
            received = 2'b10; @(posedge clk);
            #1;

            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            received = 2'b11; @(posedge clk);
            received = 2'b10; @(posedge clk);
            received = 2'b00; @(posedge clk);
            #1;

            check_outputs(3'b101, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            received = 2'b00; @(posedge clk);
            received = 2'b11; @(posedge clk);
            received = 2'b10; @(posedge clk);
            #1;

            check_outputs(3'b010, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            received = 2'b11; @(posedge clk);
            received = 2'b00; @(posedge clk);
            received = 2'b10; @(posedge clk);
            #1;

            check_outputs(3'b111, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [2:0] expected_decoded;
        input expected_valid;
        begin
            if (expected_decoded === (expected_decoded ^ decoded ^ expected_decoded) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: decoded=%h, valid=%b",
                         decoded, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded=%h, valid=%b",
                         expected_decoded, expected_valid);
                $display("  Got:      decoded=%h, valid=%b",
                         decoded, valid);
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
        $dumpvars(0,clk, received, rst, decoded, valid);
    end

endmodule
