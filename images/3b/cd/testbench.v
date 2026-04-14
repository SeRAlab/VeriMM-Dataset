`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] input_matrix;
    reg reset;
    reg start;
    wire [31:0] A;
    wire [31:0] B;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .input_matrix(input_matrix),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            input_matrix = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            input_matrix = 64'h0000_0000_0000_0000;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'h0000_0000, 32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            input_matrix = 64'h8888_8888_8888_8888;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'h8888_8888, 32'h8888_8888, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            input_matrix = 64'hFEDC_BA98_7654_3210;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'hECA8_6420, 32'hD5C4_B3A2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            input_matrix = 64'hF000_0F00_00F0_000F;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);


            #1;



            check_outputs(32'h7007_7007, 32'h7007_7007, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_A;
        input [31:0] expected_B;
        input expected_done;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h, done=%b",
                         A, B, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h, done=%b",
                         expected_A, expected_B, expected_done);
                $display("  Got:      A=%h, B=%h, done=%b",
                         A, B, done);
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
        $dumpvars(0,clk, input_matrix, reset, start, A, B, done);
    end

endmodule
