`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg rst;
    wire [6:0] encoded1;
    wire [6:0] encoded2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .encoded1(encoded1),
        .encoded2(encoded2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 5'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Input 5'b00000");
            reset_dut();
            data_in = 5'b00000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(7'h00, 7'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 5'b10000");
            reset_dut();
            data_in = 5'b10000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(7'h70, 7'h50);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 5'b00001");
            reset_dut();
            data_in = 5'b00001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(7'h07, 7'h05);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 5'b11111");
            reset_dut();
            data_in = 5'b11111;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(7'h5D, 7'h63);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input 5'b10101");
            reset_dut();
            data_in = 5'b10101;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(7'h6B, 7'h41);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input [6:0] expected_encoded1;
        input [6:0] expected_encoded2;
        begin
            if (expected_encoded1 === (expected_encoded1 ^ encoded1 ^ expected_encoded1) &&
                expected_encoded2 === (expected_encoded2 ^ encoded2 ^ expected_encoded2)) begin
                $display("PASS");
                $display("  Outputs: encoded1=%h, encoded2=%h",
                         encoded1, encoded2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded1=%h, encoded2=%h",
                         expected_encoded1, expected_encoded2);
                $display("  Got:      encoded1=%h, encoded2=%h",
                         encoded1, encoded2);
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
        $dumpvars(0,clk, data_in, rst, encoded1, encoded2);
    end

endmodule
